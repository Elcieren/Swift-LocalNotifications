## Swift-LocalNotifications Uygulama Kullanımı
| Bildirim Izni | Standart bildirim | Etkileşimli Bildirim(Daha Sonra Hatırlat) |
|---------|---------|---------|
| ![Video 1](https://github.com/user-attachments/assets/59497a87-9153-49e8-b839-7684773504ef) | ![Video 2](https://github.com/user-attachments/assets/772aac39-2a81-45da-898d-d5732078308d) | ![Video 3](https://github.com/user-attachments/assets/19682d61-ba04-4155-bbf5-bbab34c479cf) |

 <details>
    <summary><h2>Uygulma Amacı</h2></summary>
    Proje Amacı
   Bu Swift uygulaması, iOS'ta yerel bildirimlerin kullanımını göstermektedir. Uygulama, başlangıçta kullanıcıdan bildirim izni ister ve iki tür bildirim sunar: Standart Bildirim ve Etkileşimli Bildirim. Standart bildirim, kullanıcıya bir seçim sunmadan direkt bir uyarı verirken, etkileşimli bildirim kullanıcıya üç seçenek sunar: "Cevapla", "İptal Et" ve "Daha Sonra Hatırlat". Bu seçenekler, kullanıcıya daha etkileşimli bir deneyim sunar.
  </details>  

  <details>
    <summary><h2>viewDidLoad()</h2></summary>
    Uygulama başlatıldığında bildirim merkezi için bir yetkili (delegate) belirler. 
    Ayrıca, iki buton eklenir: Register (izin istemek için) ve Schedule (standart bildirim ayarlamak için) ve İnteraktif (etkileşimli bildirim ayarlamak için)
    
    ```
    override func viewDidLoad() {
    super.viewDidLoad()
    
    UNUserNotificationCenter.current().delegate = self
    navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Register", style: UIBarButtonItem.Style.plain, target: self, action: #selector(registerLocal))
    
    let button1 = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    let button2 = UIBarButtonItem(title: "İnteraktif", style: UIBarButtonItem.Style.plain, target: self, action: #selector(interaktifBildirim))
    
    navigationItem.rightBarButtonItems = [ button1 , button2]
    }
    ```
  </details> 

  <details>
    <summary><h2>@objc func registerLocal()</h2></summary>
    Kullanıcıdan uygulamanın bildirim gönderebilmesi için gerekli izinleri ister. İzin verildiğinde veya reddedildiğinde, buna göre bir mesaj basılır.

    
    ```
    @objc func registerLocal() {
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted {
            print("Bildirim izni verildi.")
        } else {
            print("Bildirim izni reddedildi.")
        }
    }
    }


    ```
  </details> 

  <details>
    <summary><h2>@objc func scheduleLocal()</h2></summary>
    5 saniye sonra tetiklenecek olan bir standart bildirim ayarlar. Bildirim başlığı ve içeriği belirlenir ve kullanıcıya bilgi vermek için basit bir uyarı gönderilir
    
    ```
     @objc func scheduleLocal(){
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    
    let content = UNMutableNotificationContent()
    content.title = "Geç Uyanma Uyarısı"
    content.body = "Erken kalkan yol alır, ama ikinci fare peyniri kapar."
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData":"fizzbuzz"]
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
    }


    
    ```
  </details> 


  <details>
    <summary><h2>@objc func interaktifBildirim()</h2></summary>
    Etkileşimli bir bildirim ayarlar. Kullanıcıya üç seçenek sunar: Cevapla (uygulamayı açar), İptal Et (bildirimi kapatır) ve Daha Sonra Hatırlat (bildirimi daha sonra tekrar gönderir).
    
    ```
    @objc func interaktifBildirim() {
    let replyAction = UNNotificationAction(identifier: "REPLY_ACTION", title: "Cevapla", options: [.foreground])
    let cancelAction = UNNotificationAction(identifier: "CANCEL_ACTION", title: "İptal Et", options: [])
    let dahaSonraAction = UNNotificationAction(identifier: "DAHA_SONRA_ACTION", title: "Bana daha sonra hatırlat", options: [])
    
    let category = UNNotificationCategory(identifier: "MESSAGE_CATEGORY", actions: [replyAction, cancelAction, dahaSonraAction], intentIdentifiers: [], options: [])
    
    let center = UNUserNotificationCenter.current()
    center.setNotificationCategories([category])
    
    let content = UNMutableNotificationContent()
    content.title = "Yeni bir mesajınız var"
    content.body = "Lütfen cevabınızı belirtin."
    content.categoryIdentifier = "MESSAGE_CATEGORY"
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    center.add(request) { error in
        if let error = error {
            print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
        } else {
            print("Bildirim başarıyla eklendi.")
        }
    }
    }


    ```
  </details> 

  <details>
    <summary><h2>func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive</h2></summary>
    Kullanıcının Daha Sonra Hatırlat seçeneğini seçmesi durumunda, bildirim 5 saniye sonra tekrar gönderilir.
    
    ```
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if response.actionIdentifier == "DAHA_SONRA_ACTION" {
        let newContent = UNMutableNotificationContent()
        newContent.title = "Hatırlatma"
        newContent.body = "Bu, daha önce istediğiniz hatırlatma bildirimi."
        newContent.sound = .default
        newContent.categoryIdentifier = response.notification.request.content.categoryIdentifier
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: newContent, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Bildirim tekrar eklenirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("5 saniye sonra tekrar bildirim ayarlandı.")
            }
        }
    }
    completionHandler()
    }


    ```
  </details> 


<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Bildirim Izni</h4>
            <img src="https://github.com/user-attachments/assets/c8cbc96b-77aa-4960-8037-3c30fdf607eb" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Standart Bildirim Gonderimi</h4>
            <img src="https://github.com/user-attachments/assets/c031621f-8309-4a46-bcd9-255c92e40b5e" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Etkileşimli Bildirim (Daha Sonra Hatirlat)</h4>
            <img src="https://github.com/user-attachments/assets/24abe072-3cab-4fc5-8319-cdcb9befd03e" style="width: 100%; height: auto;">
        </td>
      <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Daha Sonra Hatirlat Secil9ince 5 sn Yeni bir Bildirim </h4>
            <img src="https://github.com/user-attachments/assets/aecff2ac-c60a-4ca8-952f-281d04edbac5" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
