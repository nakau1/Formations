// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import CoreGraphics

class FormationTemplatePreInstalledData {
    
    func make() -> [FormationTemplate] {
        return [
            make41212,
            make4222,
            make4411,
            make442,
            make4312,
            make4231,
            make4321,
            make4141,
            make433,
            make4123,
            make4213,
            make32212,
            make31222,
            make3322,
            make3223,
            make31213,
            make32221,
        ]
    }
    
    var defaultItems: [FormationTemplateItem] {
        return [ // 4-4-2 Diamond
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.5000, 0.2420, .midfielder),
            makeItem(3,  0.2460, 0.3730, .midfielder),
            makeItem(4,  0.7730, 0.3730, .midfielder),
            makeItem(5,  0.5000, 0.5250, .midfielder),
            makeItem(6,  0.0690, 0.5680, .defender),
            makeItem(7,  0.9340, 0.5680, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
        ]
    }
    
    // 4-4-2
    
    var make442: FormationTemplate {
        return makeTemplate("4-4-2", [
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.3921, 0.3623, .midfielder),
            makeItem(3,  0.1688, 0.3663, .midfielder),
            makeItem(4,  0.8511, 0.3685, .midfielder),
            makeItem(5,  0.6325, 0.3713, .midfielder),
            makeItem(6,  0.0567, 0.6549, .defender),
            makeItem(7,  0.9375, 0.6782, .defender),
            makeItem(8,  0.3522, 0.6886, .defender),
            makeItem(9,  0.6824, 0.6919, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make4411: FormationTemplate {
        return makeTemplate("4-4-1-1", [
            makeItem(0,  0.3887, 0.1958, .forward),
            makeItem(1,  0.6092, 0.0232, .forward),
            makeItem(2,  0.6421, 0.4725, .midfielder),
            makeItem(3,  0.1320, 0.2995, .midfielder),
            makeItem(4,  0.8598, 0.3062, .midfielder),
            makeItem(5,  0.3526, 0.4816, .midfielder),
            makeItem(6,  0.0708, 0.6716, .defender),
            makeItem(7,  0.9542, 0.6816, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make41212: FormationTemplate {
        return makeTemplate("4-1-2-1-2", [
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.5000, 0.2420, .midfielder),
            makeItem(3,  0.2460, 0.3730, .midfielder),
            makeItem(4,  0.7730, 0.3730, .midfielder),
            makeItem(5,  0.5000, 0.5250, .midfielder),
            makeItem(6,  0.0690, 0.5680, .defender),
            makeItem(7,  0.9340, 0.5680, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make4222: FormationTemplate {
        return makeTemplate("4-2-2-2", [
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.2175, 0.2531, .midfielder),
            makeItem(3,  0.3679, 0.5011, .midfielder),
            makeItem(4,  0.7642, 0.2594, .midfielder),
            makeItem(5,  0.6307, 0.5128, .midfielder),
            makeItem(6,  0.0690, 0.5680, .defender),
            makeItem(7,  0.9340, 0.5680, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make4312: FormationTemplate {
        return makeTemplate("4-3-1-2", [
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.5000, 0.2620, .midfielder),
            makeItem(3,  0.5081, 0.5256, .midfielder),
            makeItem(4,  0.7123, 0.5061, .midfielder),
            makeItem(5,  0.2916, 0.4933, .midfielder),
            makeItem(6,  0.0690, 0.5680, .defender),
            makeItem(7,  0.9340, 0.5680, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    // 4-5-1
    
    var make4231: FormationTemplate {
        return makeTemplate("4-2-3-1", [
            makeItem(0,  0.4826, 0.0176, .forward),
            makeItem(1,  0.4895, 0.2030, .midfielder),
            makeItem(2,  0.1723, 0.2416, .midfielder),
            makeItem(3,  0.8153, 0.2448, .midfielder),
            makeItem(4,  0.3509, 0.4960, .midfielder),
            makeItem(5,  0.6826, 0.5055, .midfielder),
            makeItem(6,  0.0690, 0.5680, .defender),
            makeItem(7,  0.9340, 0.5680, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make4321: FormationTemplate {
        return makeTemplate("4-3-2-1", [
            makeItem(0,  0.4896, 0.0243, .forward),
            makeItem(1,  0.5987, 0.2247, .midfielder),
            makeItem(2,  0.3925, 0.2227, .midfielder),
            makeItem(3,  0.2386, 0.4259, .midfielder),
            makeItem(4,  0.7818, 0.4320, .midfielder),
            makeItem(5,  0.4965, 0.5382, .midfielder),
            makeItem(6,  0.0716, 0.6226, .defender),
            makeItem(7,  0.9393, 0.6259, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make4141: FormationTemplate {
        return makeTemplate("4-1-4-1", [
            makeItem(0,  0.4852, 0.0098, .forward),
            makeItem(1,  0.3211, 0.2309, .midfielder),
            makeItem(2,  0.6697, 0.2348, .midfielder),
            makeItem(3,  0.0697, 0.2672, .midfielder),
            makeItem(4,  0.9256, 0.2694, .midfielder),
            makeItem(5,  0.5000, 0.5250, .midfielder),
            makeItem(6,  0.0690, 0.5680, .defender),
            makeItem(7,  0.9340, 0.5680, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    // 4-3-3
    
    var make433: FormationTemplate {
        return makeTemplate("4-3-3", [
            makeItem(0,  0.1019, 0.1434, .forward),
            makeItem(1,  0.9364, 0.1679, .forward),
            makeItem(2,  0.5026, 0.0326, .forward),
            makeItem(3,  0.2495, 0.3808, .midfielder),
            makeItem(4,  0.7642, 0.3930, .midfielder),
            makeItem(5,  0.5026, 0.4381, .midfielder),
            makeItem(6,  0.0646, 0.6237, .defender),
            makeItem(7,  0.9393, 0.6181, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make4123: FormationTemplate {
        return makeTemplate("4-1-2-3", [
            makeItem(0,  0.1387, 0.1679, .forward),
            makeItem(1,  0.8469, 0.1546, .forward),
            makeItem(2,  0.4939, 0.0393, .forward),
            makeItem(3,  0.3293, 0.3240, .midfielder),
            makeItem(4,  0.6563, 0.3207, .midfielder),
            makeItem(5,  0.5000, 0.5250, .midfielder),
            makeItem(6,  0.0681, 0.6036, .defender),
            makeItem(7,  0.9401, 0.5958, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make4213: FormationTemplate {
        return makeTemplate("4-2-1-3", [
            makeItem(0,  0.1606, 0.1813, .forward),
            makeItem(1,  0.8601, 0.1980, .forward),
            makeItem(2,  0.5035, 0.0427, .forward),
            makeItem(3,  0.2978, 0.4610, .midfielder),
            makeItem(4,  0.5063, 0.2906, .midfielder),
            makeItem(5,  0.7070, 0.4727, .midfielder),
            makeItem(6,  0.0690, 0.5680, .defender),
            makeItem(7,  0.9340, 0.5680, .defender),
            makeItem(8,  0.3180, 0.7320, .defender),
            makeItem(9,  0.6780, 0.7320, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    // 3-5-2
    
    var make32212: FormationTemplate {
        return makeTemplate("3-2-2-1-2", [
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.5026, 0.2320, .midfielder),
            makeItem(3,  0.0925, 0.3173, .midfielder),
            makeItem(4,  0.9204, 0.3440, .midfielder),
            makeItem(5,  0.6640, 0.4838, .midfielder),
            makeItem(6,  0.3506, 0.4678, .midfielder),
            makeItem(7,  0.7936, 0.7128, .defender),
            makeItem(8,  0.2250, 0.7053, .defender),
            makeItem(9,  0.5069, 0.7108, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make31222: FormationTemplate {
        return makeTemplate("3-1-2-2-2", [
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.6535, 0.2999, .midfielder),
            makeItem(3,  0.3434, 0.2906, .midfielder),
            makeItem(4,  0.0930, 0.4203, .midfielder),
            makeItem(5,  0.9221, 0.4331, .midfielder),
            makeItem(6,  0.4944, 0.5101, .midfielder),
            makeItem(7,  0.2487, 0.7454, .defender),
            makeItem(8,  0.7831, 0.7473, .defender),
            makeItem(9,  0.4929, 0.7498, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make3322: FormationTemplate {
        return makeTemplate("3-3-2-2", [
            makeItem(0,  0.3580, 0.0410, .forward),
            makeItem(1,  0.6320, 0.0410, .forward),
            makeItem(2,  0.0658, 0.2409, .midfielder),
            makeItem(3,  0.5056, 0.4643, .midfielder),
            makeItem(4,  0.9256, 0.2561, .midfielder),
            makeItem(5,  0.7684, 0.4626, .midfielder),
            makeItem(6,  0.2383, 0.4600, .midfielder),
            makeItem(7,  0.7849, 0.7517, .defender),
            makeItem(8,  0.2426, 0.7487, .defender),
            makeItem(9,  0.5192, 0.7554, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    // 3-4-3
    
    var make3223: FormationTemplate {
        return makeTemplate("3-2-2-2", [
            makeItem(0,  0.0826, 0.1423, .forward),
            makeItem(1,  0.9338, 0.1345, .forward),
            makeItem(2,  0.4833, 0.0000, .forward),
            makeItem(3,  0.2171, 0.3407, .midfielder),
            makeItem(4,  0.7844, 0.3285, .midfielder),
            makeItem(5,  0.6509, 0.5328, .midfielder),
            makeItem(6,  0.3471, 0.5435, .midfielder),
            makeItem(7,  0.7963, 0.7373, .defender),
            makeItem(8,  0.2145, 0.7554, .defender),
            makeItem(9,  0.5131, 0.7576, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    var make31213: FormationTemplate {
        return makeTemplate("3-1-2-1-3", [
            makeItem(0,  0.1071, 0.1613, .forward),
            makeItem(1,  0.9171, 0.1791, .forward),
            makeItem(2,  0.4798, 0.0159, .forward),
            makeItem(3,  0.4916, 0.2405, .midfielder),
            makeItem(4,  0.7300, 0.3808, .midfielder),
            makeItem(5,  0.5000, 0.5250, .midfielder),
            makeItem(6,  0.2655, 0.3787, .midfielder),
            makeItem(7,  0.7998, 0.7451, .defender),
            makeItem(8,  0.2250, 0.7387, .defender),
            makeItem(9,  0.4955, 0.7387, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    // 3-6-1
    
    var make32221: FormationTemplate {
        return makeTemplate("3-2-2-2-1", [
            makeItem(0,  0.4869, 0.0265, .forward),
            makeItem(1,  0.7101, 0.1913, .midfielder),
            makeItem(2,  0.2904, 0.1952, .midfielder),
            makeItem(3,  0.3644, 0.5189, .midfielder),
            makeItem(4,  0.9177, 0.3062, .midfielder),
            makeItem(5,  0.6500, 0.5194, .midfielder),
            makeItem(6,  0.0751, 0.3397, .midfielder),
            makeItem(7,  0.7849, 0.7384, .defender),
            makeItem(8,  0.2399, 0.7353, .defender),
            makeItem(9,  0.5034, 0.7231, .defender),
            makeItem(10, 0.5000, 0.9200, .goalKeeper),
            ])
    }
    
    private func makeItem(_ number: Int, _ x: CGFloat, _ y: CGFloat, _ position: Position) -> FormationTemplateItem {
        let item = FormationTemplateItem()
        item.percentage = CGPercentage(x, y)
        item.position   = position
        item.number     = number
        return item
    }
    
    private func makeTemplate(_ name: String, _ items: [FormationTemplateItem]) -> FormationTemplate {
        let template = Realm.FormationTemplate.create()
        template.items.removeAll()
        template.items.append(objectsIn: items)
        
        template.name = name
        return template
    }
}
