import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var nameLabel: UILabel!
    var movieName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        nameLabel.text = movieName
        navigationItem.title = movieName
        let urlKorString =
            "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query="+movieName
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string:urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        // Do any additional setup after loading the view.
    }
}
