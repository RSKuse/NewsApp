//
//  WeatherViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/31.
//

import Foundation
import UIKit
import CoreLocation
import AVKit
import Lottie

class WeatherViewController: UIViewController, UISearchResultsUpdating, CLLocationManagerDelegate {
    
    var weatherModel: WeatherModel?
    var playerLooper: AVPlayerLooper?
    var playerLayer: AVPlayerLayer?

    
    var searchController: UISearchController!
    var cityName: String = ""
    var searchWorkItem: DispatchWorkItem?
    var isFetchingWeather = false
    let locationManager = CLLocationManager()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var lottieView: LottieAnimationView = {
            let animationView = LottieAnimationView(name: "check-mark-success")
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            animationView.animationSpeed = 0.8
            animationView.translatesAutoresizingMaskIntoConstraints = false
            return animationView
        }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pressureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupSearchController()
        setupLocationManager()
        playLottieAnimation()
    }
    private func playLottieAnimation() {
        guard let animation = LottieAnimation.named("cloudy") else {
            print("Lottie animation not found")
            return
        }
        lottieView.animation = animation
        lottieView.play()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(cityLabel)
        view.addSubview(errorLabel)
        view.addSubview(weatherImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(feelsLikeLabel)
        view.addSubview(minMaxTemperatureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(lottieView)
        view.addSubview(humidityLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(pressureLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        
        cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        weatherImageView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20).isActive = true
        weatherImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weatherImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        weatherImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        temperatureLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 20).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        feelsLikeLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10).isActive = true
        feelsLikeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        feelsLikeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        minMaxTemperatureLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: 10).isActive = true
        minMaxTemperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        minMaxTemperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: minMaxTemperatureLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        lottieView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        lottieView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lottieView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        lottieView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        humidityLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        humidityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        humidityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        windSpeedLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 10).isActive = true
        windSpeedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        windSpeedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        pressureLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 10).isActive = true
        pressureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pressureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
    }

    
    /*
     private func setWeatherBackground(for condition: String) {
         switch condition.lowercased() {
         case "clear sky.mp4":
             setVideoBackground(with: "clear_sky.mp4")  // Ensure file name matches
         case "overcast clouds":
             setVideoBackground(with: "overcast_clouds.mp4")
         case "clouds":
             setVideoBackground(with: "cloudy.mp4")  // Ensure this file exists
         default:
             setVideoBackground(with: "default.mp4")
         }
     }
     
     private func setVideoBackground(with videoName: String) {
         guard let path = Bundle.main.path(forResource: videoName, ofType: nil) else {
             print("Video file not found: \(videoName)")
             return
         }
         print("Video file path: \(path)")  // Log the file path to verify it's found
         
         let player = AVQueuePlayer(items: [AVPlayerItem(url: URL(fileURLWithPath: path))])
         playerLayer = AVPlayerLayer(player: player)
         playerLooper = AVPlayerLooper(player: player, templateItem: AVPlayerItem(url: URL(fileURLWithPath: path)))
         
         playerLayer?.frame = view.bounds
         playerLayer?.videoGravity = .resizeAspectFill
         view.layer.insertSublayer(playerLayer!, at: 0)
         player.play()
     }
     
     private func setLottieAnimation(for condition: String) {
         let animationName: String
         switch condition.lowercased() {
         case "clear sky.json":
             animationName = "clear sky.json"
         case "overcast clouds":
             animationName = "overcast_clouds"
         case "clouds":
             animationName = "cloudy.mp4"
         default:
             animationName = "defaultWeather"
         }

         print("Trying to load Lottie animation: \(animationName)")
         if let animation = LottieAnimation.named(animationName) {
             lottieView.animation = animation
             lottieView.play()
         } else {
             print("Lottie animation not found: \(animationName)")
         }
     }
     
     */

    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // Start fetching the location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            print("Location coordinates fetched: lat = \(lat), lon = \(lon)")
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    self?.showError("Unable to fetch city name")
                    return
                }
                if let placemark = placemarks?.first, let city = placemark.locality {
                    // Update the cityLabel with the detected city name
                    print("Detected city name: \(city)") // Debug statement to check city
                    DispatchQueue.main.async {
                        self?.cityLabel.text = city
                    }
                    // Fetch weather data using the detected coordinates
                    self?.fetchWeatherData(for: lat, lon: lon)
                } else {
                    self?.showError("City name not found")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        showError("Unable to get location. Please enable location services.")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            // If location permission is denied, show an error
            showError("Location services are disabled. Please enable them in settings.")
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Location access was granted, start updating location
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else { return }
        
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchWeatherData(for: query)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem) // 0.5-second debounce
    }
    
    private func fetchWeatherData(for lat: Double, lon: Double) {
        print("Fetching weather data for coordinates: lat = \(lat), lon = \(lon)")
        
        let path = "lat=\(lat)&lon=\(lon)"
            NewsService.shared.fetchData(method: .GET,
                                         baseURl: .weatherURL,
                                         path: path,
                                         model: WeatherModel.self) { [weak self] result in
            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    if weatherModel.cod == "404" {
                        self?.showError("The city may not have weather data available.")
                    } else {
                        self?.errorLabel.isHidden = true
                        self?.updateUI(with: weatherModel)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        self?.showError("Network error. Please check your internet connection.")
                    } else {
                        self?.showError("Error fetching weather: \(error.localizedDescription). Try searching for another location.")
                    }
                }
            }
        }
    }
    
    private func fetchWeatherData(for city: String) {
        
        let path = "q=\(city)"
            NewsService.shared.fetchData(method: .GET,
                                         baseURl: .weatherURL,
                                         path: path,
                                         model: WeatherModel.self) { [weak self] result in            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    if weatherModel.cod == "404" {
                        self?.showError("The city may not have weather data available.")
                    } else {
                        self?.errorLabel.isHidden = true
                        self?.updateUI(with: weatherModel)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        self?.showError("Network error. Please check your internet connection.")
                    } else {
                        self?.showError("Error fetching weather: \(error.localizedDescription). Try searching for another location.")
                    }
                }
            }
        }
    }
    
    
    private func showError(_ message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    
    private func updateUI(with model: WeatherModel) {
        if let cityName = model.name {
            cityLabel.text = cityName
        }
        
        guard let tempKelvin = model.main?.temp else { return }
        let temperatureInCelsius = tempKelvin - 273.15
        temperatureLabel.text = String(format: "%.1f°C", temperatureInCelsius)
        
        if let weatherCondition = model.weather?.first?.main {
//            setWeatherBackground(for: weatherCondition)  // Set dynamic background
//            setLottieAnimation(for: weatherCondition)   // Set Lottie animation
        }

        
        if let feelsLike = model.main?.feelsLike {
            let feelsLikeCelsius = feelsLike - 273.15
            feelsLikeLabel.text = String(format: "Feels Like: %.1f°C", feelsLikeCelsius)
        }
        
        if let tempMin = model.main?.tempMin, let tempMax = model.main?.tempMax {
            let tempMinCelsius = tempMin - 273.15
            let tempMaxCelsius = tempMax - 273.15
            minMaxTemperatureLabel.text = String(format: "Min: %.1f°C / Max: %.1f°C", tempMinCelsius, tempMaxCelsius)
        }
        
        if let weatherDescription = model.weather?.first?.description {
            descriptionLabel.text = weatherDescription.capitalized
        }
        
        if let icon = model.weather?.first?.icon {
            let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
            weatherImageView.kf.setImage(with: iconUrl)
        }
        
        if let humidity = model.main?.humidity {
            humidityLabel.text = "Humidity: \(humidity)%"
        }
        
        if let windSpeed = model.wind?.speed {
            let windSpeedKmH = windSpeed * 3.6 // Convert m/s to km/h
            windSpeedLabel.text = String(format: "Wind Speed: %.1f km/h", windSpeedKmH)
        }
        
        if let pressure = model.main?.pressure {
            pressureLabel.text = "Pressure: \(pressure) hPa"
        }
    }
}
