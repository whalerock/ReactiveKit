//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Srdan Rasic (@srdanrasic)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// A disposable that executes the given block upon disposing.
public final class BlockDisposable: DisposableType {
  
  public var isDisposed: Bool {
    return handler == nil
  }
  
  private var handler: (() -> ())?
  private let lock = RecursiveLock(name: "com.rkit.rkit.BlockDisposable")
  
  public init(_ handler: () -> ()) {
    self.handler = handler
  }
  
  public func dispose() {
    lock.lock()
    handler?()
    handler = nil
    lock.unlock()
  }
}


public class DeinitDisposable: DisposableType {
  
  public var otherDisposable: DisposableType? = nil
  
  public var isDisposed: Bool {
    return otherDisposable == nil
  }
  
  public init(disposable: DisposableType) {
    otherDisposable = disposable
  }
  
  public func dispose() {
    otherDisposable?.dispose()
  }
  
  deinit {
    otherDisposable?.dispose()
  }
}