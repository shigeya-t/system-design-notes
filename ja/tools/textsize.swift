// Measure the typical text line height (in pixels) inside each image with Vision OCR.
// Usage: swift textsize.swift <image>... ; prints TSV: path, width, height, median text height (0 if none)
import Foundation
import Vision
import AppKit

for path in CommandLine.arguments.dropFirst() {
    guard let img = NSImage(contentsOfFile: path),
          let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        print("\(path)\t0\t0\t0"); continue
    }
    let w = cg.width, h = cg.height
    let req = VNRecognizeTextRequest()
    req.recognitionLevel = .accurate
    req.usesLanguageCorrection = false
    try? VNImageRequestHandler(cgImage: cg, options: [:]).perform([req])
    var heights: [Double] = []
    for obs in req.results ?? [] {
        guard let cand = obs.topCandidates(1).first, cand.confidence > 0.3,
              cand.string.count >= 2 else { continue }
        // Rotated labels have tall bounding boxes that overstate the text size;
        // only measure lines that are clearly horizontal.
        let bw = Double(obs.boundingBox.width) * Double(w)
        let bh = Double(obs.boundingBox.height) * Double(h)
        guard bw >= bh * 1.5 else { continue }
        heights.append(bh)
    }
    heights.sort()
    let median = heights.isEmpty ? 0 : heights[heights.count / 2]
    print("\(path)\t\(w)\t\(h)\t\(String(format: "%.1f", median))")
}
