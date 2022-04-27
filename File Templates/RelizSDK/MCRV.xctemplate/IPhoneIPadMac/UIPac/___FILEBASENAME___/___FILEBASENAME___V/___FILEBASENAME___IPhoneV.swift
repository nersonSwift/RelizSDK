//  ___FILEHEADER___

import RelizKit

class ___VARIABLE_productName:identifier___IPhoneV: RZUIPacView{
    var router: ___VARIABLE_productName:identifier___R!
    
    func initActions() {}
    func create() {}
}

#if DEBUG
import SwiftUI

@available(iOS 15.0, *)
struct ___VARIABLE_productName:identifier___IPhone_Previews: PreviewProvider {
    static var previews: some View {
        RZViewWrapper {
            let v = ___VARIABLE_productName:identifier___IPhoneV()
            v.frame = UIScreen.main.bounds
            v.router = ___VARIABLE_productName:identifier___R()
            v.initActions()
            v.create()
            return v
        }
        .previewDevice("iPhone 12")
        .ignoresSafeArea(.all)
    }
}
#endif