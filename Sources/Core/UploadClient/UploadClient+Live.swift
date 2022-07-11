import Dispatch
import Foundation

extension UploadClient {
  /// Constructs a "live" upload client that uploads traces using an API client.
  ///
  /// - Parameters:
  ///   - api: An API client.
  ///   - logger: A logger.
  ///   - runEnvironment: The run environment to accompany uploaded traces.
  /// - Returns: A upload client that uses an api client.
  static func live(
    api: ApiClient,
    logger: Logger? = nil,
    runEnvironment: RunEnvironment = EnvironmentValues().runEnvironment()
  ) -> UploadClient {
    let uploadTasks = DispatchGroup()

    return UploadClient(
      upload: { trace in
        uploadTasks.enter()
        defer { uploadTasks.leave() }

        let testData = TestResults.json(runEnv: runEnvironment, data: [trace])
        logger?.debug("uploading \(testData)")

        do {
          let data = try await api.data(for: .upload(testData)).0
          if let response = try? await api.decode(data, as: UploadResponse.self) {
            logger?.debug("Uploaded result: \(response)")
            return
          } else if let response = try? await api.decode(data, as: UploadFailureResponse.self) {
            logger?.error("Failed to upload: \(response.message)")
          } else {
            throw URLError(.unknown)
          }
//          _ = try await api.data(for: .upload(testData), as: UploadResponse.self)
        } catch {
          logger?.error(error.localizedDescription)
          throw error
        }
      },
      waitForUploads: { timeout in
        let result = uploadTasks.yieldAndWait(timeout: timeout)
        if result == .timedOut {
          logger?.error("Upload client timed out before completing all uploads")
        }
      }
    )
  }
}
