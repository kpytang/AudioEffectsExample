//
//  FileBrowserViewController.swift
//  Pitch Perfect
//
//  Created by Karen Tang on 6/21/15.
//  Copyright (c) 2015 KPT. All rights reserved.
//

import UIKit
import Foundation

class FileBrowserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!

  var files: [String]!
  var dirPath: NSString!
  var fileManager: NSFileManager!
  var recordedAudio: RecordedAudio!

  override func viewDidLoad() {
    super.viewDidLoad()

    // grab files in the documents directory
    dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    fileManager = NSFileManager.defaultManager()
    let documentsUrl: NSURL = NSURL.fileURLWithPath(dirPath as String)!
    // only grab *.wav files
    if let directoryUrls =  fileManager.contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, error: nil) {
      files = directoryUrls.map(){ $0.lastPathComponent }.filter(){
        let match = ($0.lastPathComponent as String).rangeOfString("^\\d{8}-\\d{6}.wav$", options: .RegularExpressionSearch)
        return match != nil
      }
      println("wav files:\n" + files.description)
    }

    // link tableview to self
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  override func viewWillDisappear(animated: Bool) {
    tableView.setEditing(false, animated: false)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "effects") {
      let effectsViewController: EffectsViewController = segue.destinationViewController as! EffectsViewController
      let data = sender as! RecordedAudio
      effectsViewController.recordedAudio = data
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.files.count;
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
    cell.textLabel?.text = self.files[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected item #\(indexPath.row)")
    var selectedFile: NSURL = NSURL.fileURLWithPath((dirPath as String) + "/" + (self.files[indexPath.row] as String))!
    println(selectedFile)
    recordedAudio = RecordedAudio(url: selectedFile, title: selectedFile.lastPathComponent!)
    performSegueWithIdentifier("effects", sender: recordedAudio)
  }

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      println("deleting")
      // handle delete (by removing the data from your array and updating the tableview)
      var error: NSError?
      let deleteFilePath = (dirPath as String) + "/" + (self.files[indexPath.row] as String)
      if fileManager.removeItemAtPath(deleteFilePath, error: &error) {
        println("Deleted \(deleteFilePath)")
        self.files.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
      } else {
        println("Error: Did not delete file, \(error)")
      }
    }
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
    */

}
