//
//  ViewController.swift
//  Project21
//
//  Created by Eren Elçi on 12.11.2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController , UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Register", style: UIBarButtonItem.Style.plain, target: self, action: #selector(registerLocal))
        
       let button1 = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
        let button2 = UIBarButtonItem(title: "İnteraktif", style: UIBarButtonItem.Style.plain, target: self, action: #selector(interaktifBildirim))
        
        navigationItem.rightBarButtonItems = [ button1 , button2]
    }
 
    
    @objc func interaktifBildirim() {
        // Bildirim eylemlerini tanımlıyoruz
            let replyAction = UNNotificationAction(identifier: "REPLY_ACTION", title: "Cevapla", options: [.foreground])
            let cancelAction = UNNotificationAction(identifier: "CANCEL_ACTION", title: "İptal Et", options: [])
            
            // Bildirim kategorisini oluşturuyoruz
            let category = UNNotificationCategory(identifier: "MESSAGE_CATEGORY", actions: [replyAction, cancelAction], intentIdentifiers: [], options: [])
            
            // Kullanıcı bildirim merkeziyle etkileşimli kategoriyi ayarlıyoruz
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([category])
            
            // Bildirim içeriğini oluşturuyoruz
            let content = UNMutableNotificationContent()
            content.title = "Yeni bir mesajınız var"
            content.body = "Lütfen cevabınızı belirtin."
            content.categoryIdentifier = "MESSAGE_CATEGORY"  // Eylemler için kategori tanımlıyoruz
            content.sound = .default  // Varsayılan bildirim sesi
            
            // Bildirimi tetiklemek için bir zamanlayıcı ayarlıyoruz (5 saniye sonra tetiklenecek)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            // Bildirim isteğini oluşturuyoruz
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // Bildirim talebini merkeze ekliyoruz
            center.add(request) { error in
                if let error = error {
                    print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    print("Bildirim başarıyla eklendi.")
                }
            }

    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge , .sound]) { granted , error in
            if granted {
                print("Yey")
            } else {
                print("D oh!")
            }
        }
    }
    
    @objc func scheduleLocal(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = .default
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 00
       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    
}

