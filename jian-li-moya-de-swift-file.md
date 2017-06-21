# 建立Moya的Swift file

* import modules

  ```
  import Moya
  import Alamofire
  ```

* 製作Enum

* ```
  // 創建Request類型
  enum RestAPIReqeust {
      // 使用ObjectId 取得單張Photo, 使用HTTP GET方式取得, Response 的資料格式為 JSON
      case photo(objectId: String)

      // 創建單張Photo並且使用form-data方式傳送相關訊息與圖片檔案, 使用HTTP POST方法
      case createPhoto(image: Data)

      // 更新單張Photo, 使用HTTP PUT方法
      case putPhoto(objectId: String, title: String, description: String)
  }
  ```
* extension TargetType

* ```
  //  自行建立Header的參數

  extension TargetType {
      var header: [String: String] {
          return [:]
      }

      var multiParts: [Moya.MultipartFormData] {
          return []
      }
  }
  ```
* extension RestAPIReqeust: TargetType {  
      /// The target's base `URL`.  
      var baseURL: URL { get }

      /// The path to be appended to `baseURL` to form the full `URL`.
      var path: String { get }

      /// The HTTP method used in the request.
      var method: Moya.Method { get }

      /// The parameters to be encoded in the request.
      var parameters: [String: Any]? { get }

      /// The method used for parameter encoding.
      var parameterEncoding: ParameterEncoding { get }

      /// Provides stub data for use in testing.
      var sampleData: Data { get }

      /// The type of HTTP task to be performed.
      var task: Task { get }

      /// Whether or not to perform Alamofire validation. Defaults to `false`.
      var validate: Bool { get }

  }

* create custom endpoint function

* ```
  //  自行封裝Endpoint
  private func endpoint() -> (RestAPIReqeust) -> Endpoint<RestAPIReqeust> {
      let endpointClosure = { (target: RestAPIReqeust) -> Endpoint<RestAPIReqeust> in

          // 取得預設的Endpoint
          var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)

          //  加入自行定義的Header
          if !self.header.isEmpty {
              defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: self.header)
          }

          return defaultEndpoint
      }

      return endpointClosure
  }
  ```
* create function execute

* ```
  public func execute() {
      //  endpointClosure: 傳入客製化的Endpoint
      //  plugins: 啟動debugMode 會在Console印出 verbose 跟 cURL
      let provider = MoyaProvider<RestAPIReqeust>(endpointClosure: self.endpoint(),
                                              plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)])

      //  執行request, 並且以background Mode執行
      provider.request(self, queue: DispatchQueue.global(qos: .background), completion: {
          (request) in
          switch request {
          case let .success(response):
              if let _ = httpStatusCode(rawValue: response.statusCode) {
                  print("Parse Response JSON Format \(response.data)")
              } else {
                  print("Status Code :  \(response.statusCode)")
              }
          case let .failure(error):
              print("Error Status Code :  \(error.localizedDescription)")
          }
      })
  }
  ```



