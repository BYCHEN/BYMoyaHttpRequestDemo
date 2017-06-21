# 呼叫RestAPIRequest

```
 //  創建一個Photo
    if let image = UIImagePNGRepresentation(UIImage(named: "ImageFile")!) {
        RestAPIReqeust.createPhoto(image: image).execute()
    }
    
    //  取得某個Photo
    RestAPIReqeust.photo(objectId: "abcdId").execute()
    
    // 更新某個Photo
    RestAPIReqeust.putPhoto(objectId: "abcdId", title: "New Title", description: "New Description").execute()
```



