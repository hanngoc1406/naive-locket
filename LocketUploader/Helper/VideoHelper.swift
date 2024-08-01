//
//  VideoHelper.swift
//  LocketUploader
//
//  Created by Phan Đức on 31/7/24.
//

import Foundation
import AVKit

class VideoHelper {
   static func generateThumbnail(path: URL) -> UIImage? {
      do {
         let asset = AVURLAsset(url: path, options: nil)
         let imgGenerator = AVAssetImageGenerator(asset: asset)
         imgGenerator.appliesPreferredTrackTransform = true
         let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
         let thumbnail = UIImage(cgImage: cgImage)
         return thumbnail
      } catch let error {
         print("*** Error generating thumbnail: \(error.localizedDescription)")
         return nil
      }
   }
   
   static func videoDataJson(videoUrl: String, thumbUrl: String, caption: String) -> Data {
      let json = """
      {"data":{"thumbnail_url":"\(thumbUrl)",
      "video_url": "\(videoUrl)",
      "md5":"\(videoUrl.hash)",
      "recipients":[],
      "analytics":{"experiments":{"flag_4":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"43"},"flag_10":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"505"},"flag_23":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"400"},"flag_22":{"value":"1203","@type":"type.googleapis.com/google.protobuf.Int64Value"},"flag_19":{"value":"52","@type":"type.googleapis.com/google.protobuf.Int64Value"},"flag_18":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"1203"},"flag_16":{"value":"303","@type":"type.googleapis.com/google.protobuf.Int64Value"},"flag_15":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"501"},"flag_14":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"500"},"flag_25":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"23"}},"amplitude":{"device_id":"BF5D1FD7-9E4D-4F8B-AB68-B89ED20398A6","session_id":{"value":"1722437166613","@type":"type.googleapis.com/google.protobuf.Int64Value"}},"google_analytics":{"app_instance_id":"5BDC04DA16FF4B0C9CA14FFB9C502900"},"platform":"ios"},
      "sent_to_all":true,"caption":"\(caption)","overlays":[{"data":{"text":"\(caption)","text_color":"#FFFFFFE6","type":"standard","max_lines":{"@type":"type.googleapis.com/google.protobuf.Int64Value","value":"4"},"background":{"material_blur":"ultra_thin","colors":[]}},"alt_text":"\(caption)","overlay_id":"caption:standard","overlay_type":"caption"}]}}
      """
      
      return json.data(using: .utf8)!
   }
}
