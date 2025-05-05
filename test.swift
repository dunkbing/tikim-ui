import Foundation
import JavaScriptCore

// Create a JavaScript context
let context = JSContext()!

// Set up a basic console.log for debugging
let console = JSValue(object: [:], in: context)
let consoleLog: @convention(block) (JSValue) -> Void = { args in
    print("JS console.log: \(args)")
}
//let consoleLog: (JSValue) -> Void = { args in
//    print("JS console.log: \(args)")
//}
console?.setObject(consoleLog, forKeyedSubscript: "log" as NSString)
context.setObject(console, forKeyedSubscript: "console" as NSString)

// Function WITHOUT @convention(block)
let regularFunction = { (message: String) in
    print("Regular function called with: \(message)")
}

// Function WITH @convention(block)
let blockFunction: @convention(block) (String) -> Void = { message in
    print("Block function called with: \(message)")
}

// Expose both functions to JavaScript
context.setObject(regularFunction, forKeyedSubscript: "regularFunction" as NSString)
context.setObject(blockFunction, forKeyedSubscript: "blockFunction" as NSString)

// Execute JavaScript that attempts to call both functions
print("\n--- Executing JavaScript ---")
let result = context.evaluateScript(
    """
        console.log("About to call regularFunction...");
        // This call might not work as expected
        //regularFunction("Hello from regularFunction");

        console.log("About to call blockFunction...");
        // This call will work as expected
        blockFunction('Hello from JS');
    """)
print(result?.toString() ?? "undefined")
//let result = context.evaluateScript(
//    """
//        console.log("About to call regularFunction...");
//        try {
//            regularFunction("Hello from regularFunction");
//        } catch (e) {
//            console.log("Error calling regularFunction: " + e);
//        }

//        console.log("About to call blockFunction...");
//        try {
//            blockFunction("Hello from blockFunction");
//        } catch (e) {
//            console.log("Error calling blockFunction: " + e);
//        }

//        "Script execution completed";
//    """)

//print("\n--- JavaScript execution result ---")
//print(result?.toString() ?? "undefined")

//// Another example with return values
//let regularAdd = { (a: Int, b: Int) -> Int in
//    return a + b
//}

//let blockAdd: @convention(block) (Int, Int) -> Int = { a, b in
//    return a + b
//}

//context.setObject(regularAdd, forKeyedSubscript: "regularAdd" as NSString)
//context.setObject(blockAdd, forKeyedSubscript: "blockAdd" as NSString)

//print("\n--- Testing functions with return values ---")
//let addResult = context.evaluateScript(
//    """
//        try {
//            let regularResult = regularAdd(5, 3);
//            console.log("regularAdd result: " + regularResult);
//            regularResult
//        } catch (e) {
//            console.log("Error calling regularAdd: " + e);
//        }

//        try {
//            let blockResult = blockAdd(5, 3);
//            console.log("blockAdd result: " + blockResult);
//            blockResult;
//        } catch (e) {
//            console.log("Error calling blockAdd: " + e);
//        }
//    """)

//print("\nProgram completed.")
//print(addResult?.toString() ?? "undefined")
