import UIKit


// crashes when called on an optimized build (-O or -Osize)
// this exact repro only crashes on the simulator, but there are other repros that also crash on the device
func crash() {
	_ = ProblematicEnum.problematicCase.problematicMethod()
}

enum ProblematicEnum {
	case first, second, problematicCase
	
	func problematicMethod() -> SomeClass {
		let someVariable: SomeClass
		
		switch self {
		case .first:
			someVariable = SomeClass()
		case .second:
			someVariable = SomeClass()
		case .problematicCase:
			someVariable = SomeClass(someParameter: NSObject())
			_ = NSObject().description
			return someVariable // EXC_BAD_ACCESS (simulator: EXC_I386_GPFLT)
		}
		
		let _ = [someVariable]
		return SomeClass(someParameter: NSObject())
	}
	
}

class SomeClass: NSObject {
	override init() {}
	init(someParameter: NSObject) {}
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		crash()

		return true
	}

}

