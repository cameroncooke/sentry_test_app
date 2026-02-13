import SwiftUI

struct ContentView: View {
    @State private var viewModel = HackerNewsFeedViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading && viewModel.stories.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }

                if let errorMessage = viewModel.errorMessage, viewModel.stories.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Couldn't load feed")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                    .padding(.vertical, 2)
                }

                ForEach(viewModel.stories) { story in
                    Link(destination: story.destinationURL) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(story.title)
                                .font(.headline)
                                .lineLimit(3)
                            Text("\(story.score) pts")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("HN")
            .task {
                await viewModel.loadIfNeeded()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

private struct HackerNewsStory: Identifiable, Decodable {
    let id: Int
    let title: String
    let score: Int
    let url: String?

    var destinationURL: URL {
        if let url, let parsed = URL(string: url) {
            return parsed
        }
        return URL(string: "https://news.ycombinator.com/item?id=\(id)")!
    }
}

@MainActor
@Observable
private final class HackerNewsFeedViewModel {
    private let service = HackerNewsService()

    var stories: [HackerNewsStory] = []
    var isLoading = false
    var errorMessage: String?

    func loadIfNeeded() async {
        guard stories.isEmpty else { return }
        await refresh()
    }

    func refresh() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            stories = try await service.fetchTopStories(limit: 15)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

private struct HackerNewsService {
    private let session = URLSession.shared

    func fetchTopStories(limit: Int) async throws -> [HackerNewsStory] {
        let topStoryIDsURL = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json")!
        let (idData, _) = try await session.data(from: topStoryIDsURL)
        let ids = try JSONDecoder().decode([Int].self, from: idData)

        let selectedIDs = Array(ids.prefix(limit))

        return try await withThrowingTaskGroup(of: HackerNewsStory?.self) { group in
            for id in selectedIDs {
                group.addTask {
                    try await fetchStory(id: id)
                }
            }

            var fetched: [HackerNewsStory] = []
            for try await story in group {
                if let story {
                    fetched.append(story)
                }
            }

            let indexLookup = Dictionary(uniqueKeysWithValues: selectedIDs.enumerated().map { ($0.element, $0.offset) })
            return fetched.sorted {
                (indexLookup[$0.id] ?? .max) < (indexLookup[$1.id] ?? .max)
            }
        }
    }

    private func fetchStory(id: Int) async throws -> HackerNewsStory? {
        let storyURL = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!
        let (data, _) = try await session.data(from: storyURL)
        return try JSONDecoder().decode(HackerNewsStory?.self, from: data)
    }
}

#Preview {
    ContentView()
}
