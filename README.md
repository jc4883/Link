# Background
Link is an iOS application for college students to plan hangouts without texting. It uses **Swift**, **Firebase**, **Google Maps API**,and **UIKit**.

## Inspiration
At Columbia University, I found myself hating to text. I wanted a way to invite people casually to lunch or a quick hangout session between classes. I needed a solution that was more lightweight than something like Facebook Events, and something quicker than texting. That's why I made Link, which allows users to send event requests to whoever they want, wherever they want, and whenever they want, all within seconds. 

## Features

### User Signup

I implemented user signup and login using Google's Firebase authentication. During signup, the user is able to choose a profile picture to go along with their account.

This is what the signup process looks like:

![](link_signup_demo.gif)


Choosing the photo was implemented using a `handlePlusPhoto()` method which instantiates an UIImagePickerController. Here is a code snippet of the method:

```Swift 
      @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
```

When the user signs up, the photo is then saved to Firebase Storage and the user information is saved to the Firebase Database, with only the url of the file:

```Swift
  Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
    if let error = error {
        print("sign up errno: ", error)
    }
    guard let image = self.plusPhotoButton.imageView?.image else{return}
    guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
    let filename = UUID().uuidString //unique string for each profile pic
    //add unique child and its profile pic to storage
    let storageRef = Storage.storage().reference().child("profile_images").child(filename)
    storageRef.putData(uploadData, metadata: nil, completion:
    ...
    )
  }
```


### Events

Link deploys a Firebase Realtime NoSQL Database to allow eager-loading of user events and invitations data, resulting in minimal loading times and fluid user experience. When a user creates a new event, it is stored to the Firebase Database. Here is what that looks like:

![](link_event_create_demo.gif)

I was able to fetch the events, or "Links", using a `fetchOrderedLinks()` method which retreives the relevant data.

```Swift
  fileprivate func fetchOrderedLinks() {
      guard let uid = Auth.auth().currentUser?.uid else {return}
      let ref = Database.database().reference().child("links").child(uid)
      ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in

          guard let dictionary = snapshot.value as? [String : Any] else {return}

          let link = Link(dictionary: dictionary)
          self.links.append(link)
          self.collectionView.reloadData()


      }) { (err) in
          print("failed to fetch ordered links: ", err)
      }
  }
```

 Here, I order the links by creation date, allowing users to see their events in a chronological order.
 
### Google Maps API

Link also features a map that utilizes the Google Maps API to select the specific location where the user would like to meet his invitees. Here is how the map is initially constructed in the MapController:

```Swift
  let mapView : GMSMapView = {
      let camera = GMSCameraPosition.camera(withLatitude: 40.808031, longitude: -73.963753, zoom: 12)
      let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
      mapView.isMyLocationEnabled = true
      return mapView
  }()
```

This mapView is used elsewhere in the controller to find the coordinates which the user specifies by using `mapView.camera.target`. 

## In Conclusion

Thanks for checking out Link! This was a very educational project for me to learn Swift and NoSQL databases, and I had a ton of fun making it. I hope you've enjoyed seeing some of the features of Link and poking around its source code.

To see more of my projects, checkout my [portfolio](https://jc4883.github.io/), and make sure to look around my [Github](https://github.com/jc4883) as well.

Finally, go to my [LinkedIn](https://www.linkedin.com/in/peterchoi24/) to learn more about me.
