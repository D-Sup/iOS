import UIKit
import WebKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlKorString = "https://map.naver.com/v5/search/영화관"
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string:urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


