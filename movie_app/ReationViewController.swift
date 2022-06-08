import UIKit
import WebKit


struct MovieData2 : Codable {
    
    let  boxOfficeResult : boxOfficeResult
    
}

struct  boxOfficeResult : Codable {
    
    let  dailyBoxOfficeList : [dailyBoxOfficeList]
    
}

struct  dailyBoxOfficeList : Codable {
    
    let  movieNm : String
    
    let  audiCnt : String
    
    let  audiAcc : String
    
}
class ReationViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    var movieData : MovieData2?
    @IBOutlet weak var web2View: WKWebView!
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b1cb31fb52039f91d4527100e5827c06&targetDt="
    override func viewDidLoad() {
        super.viewDidLoad()
        movieURL += makeYesterdayString()
        getData()
       
        
    }
    func makeYesterdayString() -> String {
        let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyyMMdd"
        let day = dateF.string(from: y)
        return day
    }
    
    func getData(){
        guard let url = URL(string: movieURL) else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                guard let JSONdata = data else { return }
                    let dataString = String(data: JSONdata, encoding: .utf8)
//                    print(dataString!)
                    let decorder = JSONDecoder()
                    do{
                        let decodedData = try decorder.decode(MovieData2.self, from: JSONdata)
                        let urlKorString2 =
                            "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query="+decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm+" 평점"
                        let urlString2 = urlKorString2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        guard let url2 = URL(string:urlString2) else { return }
                        let request2 = URLRequest(url: url2)
                        web2View.load(request2)
                        self.movieData = decodedData
                    }catch{
                        print(error)
                    }
            }
            task.resume()
        }
}
