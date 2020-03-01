import UIKit
import Parse
import AudioToolbox
import Kingfisher

class EventCell: UICollectionViewCell {
    
    /* Views */
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var dayNrLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
}


class HomeViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var eventsCollView: UICollectionView!
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTxt: UITextField!
    
    @IBOutlet weak var searchOutlet: UIBarButtonItem!
    
    /* Variables */
    var eventsArray = [Event]()
    var cellSize = CGSize()
    var searchViewIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set size of the event cells
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            cellSize = CGSize(width: view.frame.size.width-30, height: 270)
        } else  {
            // iPad
            cellSize = CGSize(width: 350, height: 270)
        }
        
        
        // Search View initial setup
        searchView.frame.origin.y = -searchView.frame.size.height
        searchView.layer.cornerRadius = 10
        searchViewIsVisible = false
        searchTxt.resignFirstResponder()
        
        // Set placeholder's color and text for Search text fields
        searchTxt.attributedPlaceholder = NSAttributedString(string: "Type an event name (or leave it blank)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
        
        navigationController?.hidesBarsWhenKeyboardAppears = false

        
        // Call a Parse query
        queryLatestEvents()
    }
    
    
    
    // MARK: - Get latest events
    func queryLatestEvents() {
        showHUD()
        
        self.eventsArray = [
            Event(
                id: "1",
                title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                location: "Vidya Mawatha, Colombo 07",
                description: "Praesent convallis aliquam tincidunt. Maecenas porta ullamcorper arcu, nec tempus magna pulvinar ac.", website: "",
                startDate: Date(),
                endDate: Date(),
                cost: "Free",
                image: "https://previews.123rf.com/images/jiadt/jiadt1911/jiadt191100007/133455623-reflection-of-riverside-city-and-cruise-ship.jpg",
                isPending: false,
                keywords: "nibm",
                user: "rQKfZY5UfcPjIBHqrZvRLYOqdii2"
            ),
            Event(
                id: "2",
                title: "Proin bibendum erat nec nisl vestibulum laoreet.",
                location: "NIBM",
                description: "Nulla pharetra consectetur felis. Pellentesque semper id neque quis ultricies.", website: "",
                startDate: Date(),
                endDate: Date(),
                cost: "Free",
                image: "https://previews.123rf.com/images/jiadt/jiadt1911/jiadt191100007/133455623-reflection-of-riverside-city-and-cruise-ship.jpg",
                isPending: false,
                keywords: "nibm",
                user: "rQKfZY5UfcPjIBHqrZvRLYOqdii2"
            )
        ]
        
        self.hideHUD()
        
//        let query = PFQuery(className: EVENTS_CLASS_NAME)
//
//        let now = Date()
//        query.whereKey(EVENTS_END_DATE, greaterThan: now)
//
//        query.whereKey(EVENTS_IS_PENDING, equalTo: false)
//        query.order(byDescending: EVENTS_START_DATE)
//        query.limit = limitForRecentEventsQuery
//        // Query block
//        query.findObjectsInBackground { (objects, error)-> Void in
//            if error == nil {
//                self.eventsArray = objects!
//                self.eventsCollView.reloadData()
//                self.hideHUD()
//
//            } else {
//                self.simpleAlert("\(error!.localizedDescription)")
//                self.hideHUD()
//            }}
        
    }
    
    // MARK: -  COLLECTION VIEW DELEGATES
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
        
        let event = eventsArray[indexPath.row]
        
        let url = URL(string: event.image)
        cell.eventImage.kf.setImage(with: url)
                
        cell.profileImage.kf.setImage(with: url)
        cell.bringSubviewToFront(cell.profileImage)
        cell.superview?.bringSubviewToFront(cell.profileImage)


        // get event start date (for the labels on the left side of the event's image)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let dayStr = dayFormatter.string(from: eventsArray[indexPath.row].startDate as! Date)
        cell.dayNrLabel.text = dayStr
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let monthStr = monthFormatter.string(from: eventsArray[indexPath.row].startDate as! Date)
        cell.monthLabel.text = monthStr
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let yearStr = yearFormatter.string(from: eventsArray[indexPath.row].startDate as! Date)
        cell.yearLabel.text = yearStr
        
        
        // get event title
        cell.titleLbl.text = "\(event.title)".uppercased()
        
        // get event location
        cell.locationLabel.text = "\(event.location)".uppercased()

        // Get event start date, end date and time
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM dd @hh:mm a"
        let startDateStr = startDateFormatter.string(from: event.startDate as! Date).uppercased()
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "MMM dd @hh:mm a"
        let endDateStr = endDateFormatter.string(from: event.endDate as! Date).uppercased()
        
        if startDateStr == endDateStr {  cell.timeLabel.text = startDateStr
        } else {  cell.timeLabel.text = "\(startDateStr) - \(endDateStr)"
        }
        
        // get event cost
        cell.costLabel.text = event.cost.uppercased()
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    
    // MARK: - Tap a cell to open event details view controller
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let event = eventsArray[indexPath.row]
        
        hideSearchView()
        
        let eventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetails") as! EventDetailsViewController
        eventDetailsViewController.eventObj = event
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
        
    }
    
    
    
    
    
    
    // MARK: - Search events button
    @IBAction func searchButt(_ sender: AnyObject) {
        searchViewIsVisible = !searchViewIsVisible
        
        if searchViewIsVisible {
            showSearchView()
        } else {
            hideSearchView()
        }
    }
    
    
    // MARK: - Textfield deligate (tap Search on the keyboard to launch a search query) */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideSearchView()
//        showHUD()
//
//        // Make a new Parse query
//        eventsArray.removeAll()
//        let keywords = searchTxt.text!.lowercased().components(separatedBy: " ")
//        print("\(keywords)")
//
//        let query = PFQuery(className: EVENTS_CLASS_NAME)
//        if searchTxt.text != ""   { query.whereKey(EVENTS_KEYWORDS, containedIn: keywords) }
//        query.whereKey(EVENTS_IS_PENDING, equalTo: false)
//
//
//        // Query block
//        query.findObjectsInBackground { (objects, error)-> Void in
//            if error == nil {
//                self.eventsArray = objects!
//
//                // EVENT FOUND
//                if self.eventsArray.count > 0 {
//                    self.eventsCollView.reloadData()
//                    self.title = "Events Found"
//                    self.hideHUD()
//
//                    // EVENT NOT FOUND
//                } else {
//                    self.simpleAlert("No results. Please try a different search")
//                    self.hideHUD()
//
//                    self.queryLatestEvents()
//                }
//
//                // error found
//            } else {
//                self.simpleAlert("\(error!.localizedDescription)")
//                self.hideHUD()
//            }}


        return true
    }
    
    
    
    
    // MARK: - Show/Hide search view
    func showSearchView() {
        searchTxt.becomeFirstResponder()
        searchTxt.text = ""
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
            self.searchView.frame.origin.y = 64
        }, completion: { (finished: Bool) in })
    }
    
    func hideSearchView() {
        searchTxt.resignFirstResponder()
        searchViewIsVisible = false
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.searchView.frame.origin.y = -self.searchView.frame.size.height
        }, completion: { (finished: Bool) in })
    }
    
    // MARK: - Refresh button
    @IBAction func refreshButt(_ sender: AnyObject) {
        queryLatestEvents()
        searchTxt.resignFirstResponder()
        hideSearchView()
        searchViewIsVisible = false
        
        self.title = "Recent Events"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
