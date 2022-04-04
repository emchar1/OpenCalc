//
//  AudioPlayer.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import AVFoundation

/**
 A simple audio player.
 */
struct AudioPlayer {
    static var player: AVAudioPlayer?
    
    static func playSound(filename: String, volume: Float = 0.1) {
        guard !K.muteOn else { return }
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.volume = volume
            player.play()
        }
        catch {
            print("Error loading \(filename)")
        }
    }
}
