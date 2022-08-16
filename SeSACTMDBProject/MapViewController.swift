//
//  MapViewController.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/11.
//

import UIKit
import MapKit

import CoreLocation
import AVFoundation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
//        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
//        setRegionAndAnnotation(center: center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        showRequestLocationServiceAlert()
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 설정: 애플맵 활용해 좌표 복사
//        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        
        // 지도 기반으로 보이는 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "이곳은.. 영등포 캠퍼스"
        
        // 지도에 핀 추가
        mapView.addAnnotation(annotation)
    }

}

extension MapViewController: CLLocationManagerDelegate {
    // 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
        }
        
        // 위치 업데이트 멈추기
        locationManager.stopUpdatingLocation()
        
    }
    
    // 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // iOS 14 이상: 사용자의 권한 상태가 변경이 될 때, 위치 관리자 생성할 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

extension MapViewController {
    // Location 7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    // 위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            // 프로퍼티를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크: locationServicesEnabled()
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    // Location 8. 사용자의 위치 권한 상태 확인
    // 사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인 (단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            // plist WhenInUse -> request 메서드 OK
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // 사용자가 위치 허용해두면 startUpdatingLocation을 통해 didUpdateLocations 메서드 실행됨
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          
          // 설정까지 이동하거나 설정 세부화면까지 이동하거나
          // 한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 <- 설정 화면까지 이동
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
//    func setSearch
}
