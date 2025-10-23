//
//  GoogleAdMobTestUnit.swift
//  GoogleAdMobExample
//
//  Created by Đỗ Việt on 16/10/25.
//

import SwiftUI
import Foundation

public enum GoogleAdMobUnitId {
#if DEBUG
    public static let banner = "ca-app-pub-3940256099942544/2934735716"
    public static let adaptiveBanner = "ca-app-pub-3940256099942544/2435281174"
    public static let appOpen = "ca-app-pub-3940256099942544/5575463023"
    public static let interstitial = "ca-app-pub-3940256099942544/4411468910"
    public static let interstitialVideo = "ca-app-pub-3940256099942544/5135589807"
    public static let rewarded = "ca-app-pub-3940256099942544/1712485313"
    public static let rewardedInterstitial = "ca-app-pub-3940256099942544/6978759866"
    public static let nativeAdvanced = "ca-app-pub-3940256099942544/3986624511"
    public static let nativeAdvancedVidoe = "ca-app-pub-3940256099942544/2521693316"
#else
    public static let banner = ""
    public static let adaptiveBanner = ""
    public static let appOpen = ""
    public static let interstitial = ""
    public static let interstitialVideo = ""
    public static let rewarded = ""
    public static let rewardedInterstitial = ""
    public static let nativeAdvanced = ""
    public static let nativeAdvancedVidoe = ""
#endif
}
