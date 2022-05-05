//
//  RZVBTemplateExtension.swift
//  Example
//
//  Created by Александр Сенин on 07.10.2021.
//

import RZViewBuilderKit


//MARK: - TapMode
extension RZVBTemplate where View: UIButton{
    public enum TapMode {
        case alpha
        case reduce
        case impact
    }
    
    public static func tapMode(_ value: TapMode = .alpha) -> Self{
        switch value {
        case .alpha:
            return .custom {
                $0+>.template($0.rzState.switcher([
                    .normal:      .custom {$0+>.alpha(1)},
                    .highlighted: .custom {$0+>.alpha(0.7)}
                ])?.animation(.duration(0.1)))
            }
        case .reduce:
            return .custom {
                $0+>.template($0.rzState.switcher([
                    .normal:      .custom {$0+>.ta(1).td(1)},
                    .highlighted: .custom {$0+>.ta(0.95).td(0.95)}
                ])?.animation(.duration(0.1)))
            }
        case .impact:
            return .custom {
                var start: CFAbsoluteTime = 0
                $0+>.template($0.rzState.switcher([
                    .normal: .custom { _ in
                        if (CFAbsoluteTimeGetCurrent() - start) < 0.2 { return }
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    },
                    .highlighted: .custom { _ in
                        start = CFAbsoluteTimeGetCurrent()
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                ]), false)
            }
        }
    }
}

