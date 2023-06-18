import Foundation

func processOutput(_ line: String) {
    let regex = try! NSRegularExpression(pattern: "Cameras changed to \\[(.*?)\\]", options: .caseInsensitive)
    let results = regex.matches(in: line, options: [], range: NSMakeRange(0, line.count))
    guard let match = results.first else { return }
    let range = match.range(at: 1)
    guard let r = Range(range, in: line) else { return }
    let cameraName = String(line[r])

    print("\(cameraName)")

    var urlString = "http://signpost.local/screen/?text="
    if !cameraName.isEmpty {
        urlString += "%20ON%20AIR"
    } else {
        urlString += ""
    }
    
    if let url = URL(string: urlString) {
         let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
             if let httpResponse = response as? HTTPURLResponse {
                 if httpResponse.statusCode != 200 {
                     print("Onair failed with status code: \(httpResponse.statusCode)")
                 }
             }
         }
         task.resume()
     } else {
         print("Invalid URL")
     }
    
    }

func main() {
    let command = "log stream --predicate 'eventMessage contains \"Cameras changed to\"'"
    let process = Process()
    process.launchPath = "/bin/sh"
    process.arguments = ["-c", command]

    let pipe = Pipe()
    process.standardOutput = pipe

    let outHandle = pipe.fileHandleForReading
    outHandle.waitForDataInBackgroundAndNotify()

    let dataObserver : NSObjectProtocol = NotificationCenter.default.addObserver(
        forName: NSNotification.Name.NSFileHandleDataAvailable,
        object: outHandle, queue: nil) {  _ -> Void in
            let data = outHandle.availableData
            if data.count > 0 {
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    processOutput(str.trimmingCharacters(in: .whitespacesAndNewlines))
                }
                outHandle.waitForDataInBackgroundAndNotify()
            }
        }

    let terminationObserver : NSObjectProtocol = NotificationCenter.default.addObserver(
        forName: Process.didTerminateNotification,
        object: process, queue: nil) { _ -> Void in
            NotificationCenter.default.removeObserver(dataObserver)
        }

    process.launch()
    process.waitUntilExit()
    NotificationCenter.default.removeObserver(terminationObserver)
}

main()

