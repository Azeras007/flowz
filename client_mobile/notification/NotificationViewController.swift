import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var logsLabel: UILabel!  // Par exemple, un UILabel pour afficher les logs

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Cette méthode est appelée lorsque la notification est reçue
    func didReceive(_ notification: UNNotification) {
        // Récupérer les logs depuis le payload de la notification
        let userInfo = notification.request.content.userInfo
        if let logs = userInfo["logs"] as? String {
            logsLabel.text = logs  // Afficher les logs dans l'interface
        }
    }
}
