import UIKit

struct MovieData : Codable {
    
    let  boxOfficeResult : BoxOfficeResult
    
}

struct  BoxOfficeResult : Codable {
    
    let  dailyBoxOfficeList : [DailyBoxOfficeList]
    
}

struct  DailyBoxOfficeList : Codable {
    
    let  movieNm : String
    
    let  audiCnt : String
    
    let  audiAcc : String
    
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var table: UITableView!
    var movieData : MovieData?
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b1cb31fb52039f91d4527100e5827c06&targetDt="
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.movieName.text = indexPath.description
        //        cell.movieName.text = name[indexPath.row]
        cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        if let aCnt = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiCnt {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let aCount = Int(aCnt)!
            let result = numF.string(for: aCount)! + "명"
            cell.audiCount.text = "어제:\(result)"
        }
        if let aAcc = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc {
            cell.aduiAccumulate.text = "누적:\(aAcc)명"
        }
        return cell
//        cell.audiCount.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiCnt
//        cell.aduiAccumulate.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc
//        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "박스오피스(영화진흥위원회제공:" + makeYesterdayString()+")"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? DetailViewController else{return}
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
        
        dest.movieName = (movieData?.boxOfficeResult.dailyBoxOfficeList[row].movieNm)!
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
                    //                    print(JSOdata)
                    //                    print(response!)
                    let dataString = String(data: JSONdata, encoding: .utf8)
                    print(dataString!)
                    let decorder = JSONDecoder()
                    do{
                        let decodedData = try decorder.decode(MovieData.self, from: JSONdata)
//                                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                        self.movieData = decodedData
                    }catch{
                        print(error)
                    }
            }
            task.resume()
        }
        // Do any additional setup after loading the view.
}

