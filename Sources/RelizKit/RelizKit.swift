
@_exported import Foundation
@_exported import UIKit
@_exported import SwiftUI

#if canImport(RZEventKit)
@_exported import RZEventKit
#endif

#if canImport(RZStoreKit)
@_exported import RZStoreKit
#endif

#if canImport(RZObservableKit)
@_exported import RZObservableKit
#endif


//MARK: - RZUIKit
#if canImport(RZDarkModeKit)
@_exported import RZDarkModeKit
#endif

#if canImport(RZUIPacKitKit)
@_exported import RZUIPacKit
#endif

#if canImport(RZViewBuilder)
@_exported import RZViewBuilderKit
#endif


class RelizKit{
    static func testimport(){
        #if canImport(RZEventKit)
            print("RZEventKit")
        #endif

        #if canImport(RZStoreKit)
            print("RZStoreKit")
        #endif

        #if canImport(RZObservableKit)
            print("RZObservableKit")
        #endif


        //MARK: - RZUIKit
        #if canImport(RZDarkModeKit)
            print("RZDarkModeKit")
        #endif

        #if canImport(RZUIPacKitKit)
            print("RZUIPacKitKit")
        #endif

        #if canImport(RZViewBuilder)
            print("RZViewBuilder")
        #endif
    }
}
