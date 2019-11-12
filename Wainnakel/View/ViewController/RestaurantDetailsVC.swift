
import UIKit
import MapKit
class RestaurantDetailsVC: UIViewController  {
    // **************Outlet and objects****************
    @IBOutlet var restaurantNameLbl: UILabel!
    @IBOutlet var restaurantRankLbl: UILabel!
    @IBOutlet var googleMapPic: UIImageView!
    @IBOutlet var mapProp: MKMapView!
    @IBOutlet var getRestaurantBtnProp: TransitionButton!
    var vm : RestaurantDetailsVM!
    //********************************************
    @IBAction func getAntherRestaurantAction(_ sender: Any) {
        if(mapProp.annotations.count > 0){self.mapProp.removeAnnotations(self.mapProp.annotations)}
        vm.fetchRestaurantDetails()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerConfiguration()
        googleMapConfiguration()
        vm.delegate = self
    }
    func navigationControllerConfiguration()
    {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "وين ناكل"
        let menuButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action:nil)
        menuButton.image = UIImage(named:"menu-three-horizontal-lines-symbol")
        self.navigationItem.rightBarButtonItems = [menuButton]
    }
    @objc func openGoogleMap(_ sender:AnyObject){
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(vm.restaurantLat),\(vm.restaurantLon)&zoom=14&views=traffic&q=\(vm.restaurantLat),\(vm.restaurantLon)")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
        }
    }
    func bindData()
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: vm.restaurantLat, longitude: vm.restaurantLon)
        mapProp.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: (annotation.coordinate), latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        mapProp.setRegion(mapProp.regionThatFits(region), animated: true)
        restaurantNameLbl.text = vm.restaurantName
        restaurantRankLbl.text = vm.restaurantCategoryAndRank
    }
    override func viewWillAppear(_ animated: Bool) {
        bindData()
    }
}
extension RestaurantDetailsVC : RestaurantDelegate
{
    func showLoading() {
        getRestaurantBtnProp.startAnimation() //start the animation when the user tap the button
    }
    func showAlert(message: String) {
        alert(title: "validation",message: message)
    }
    func callBack()
    {
        getRestaurantBtnProp.stopAnimation(animationStyle: .normal, completion: {
            self.bindData()
        })
    }
}
extension RestaurantDetailsVC : MKMapViewDelegate
{
    func googleMapConfiguration()
    {
        mapProp.delegate = self
        googleMapPic.isUserInteractionEnabled = true
        googleMapPic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RestaurantDetailsVC.openGoogleMap(_:))))
    }
    func mapView(_ ProfileMapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = ProfileMapView.dequeueReusableAnnotationView(withIdentifier: "ProfilePinView")
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "ProfilePinView")}
        pinView!.image = UIImage(named: "icons8-marker-48")
        return pinView
        
    }
}
