import UIKit

// KVO = key value observing

//KVO is an observer pattern
// notifcationCenter is also an observer pattern


//KVO is a one to many pattern relationship as opposed to delegation which is a one to one

// in the delegation pattern
// class ViewController: UIViewController {}
// example tavbleview.datasource = self

// KVO is an Objective-C runtime API
// Along with KVO beinf an objective-c runtime some essentials are required

// 1. The object being observed needs to be a class
// 2. The class needs to be inherit from NSObject, NSObject is the top abstract class in objective-C The class also needs to be marked @objc
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic means that the property is being dynamically dispatched (at runtime the compiler verifies the underlying property)

// In swift types are statically dispatched which means they are checked at compile time vs Objective-C which is dynamically dispatched and checked at the runtime

// Static v dynamic dispatch

//https://medium.com/flawless-app-stories/static-vs-dynamic-dispatch-in-swift-a-decisive-choice-cece1e872d

//Dog class (class being observed) - will have property to be observed

// we also use NSObject for locations calls

@objc
class Dog: NSObject { // Dog is KVO-compliant
    var name: String
    @objc dynamic var age: Int // age is a observable property
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// observer class one
class DogWalker {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? // a handle for the property being observed example age property on Dog
    //similar to ListenerRegistration in Firebase
    //example ListenerRegistration: ListenerRegistration
    init(dog: Dog) {
        self.dog = dog
        confirgureBirthdayObservation() // this needs to be called either in the init or the view did load
    }
    private func confirgureBirthdayObservation() {
        // \.dog is keyPath syntax for KVO observing
        //options we are listening to the old value and the new value
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            // update UI accordingly id in a viewController class
            // oldValue example 5
            // newValue example 6
            guard let age = change.newValue else { return }
            print("Hey \(dog.name), happy \(age) birthday from the dog walker")
            print("grommer oldValue: \(change.oldValue ?? 0) ")
            print("groomer newValue: \(change.newValue ?? 0)")
        })
    }
    
    
}

// observer class two

class DogGroomer {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation
    
    init(dog: Dog) {
        self.dog = dog
    }
    private func confirgureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            <#code#>
        })
    }
    
}

// test out KVO observing on the .age property of Dog
// both classes DogWalker and DogGroomer should get .age changes)

let snoopy = Dog(name: "Snoopy", age: 5)
let dogWalker = DogWalker(dog: snoopy) // both dog walker and dogGroomer have a referebce to snoopy
let dogGroomer = DogGroomer(dog: snoopy)

snoopy.age += 1 // increment from 5 to 6
