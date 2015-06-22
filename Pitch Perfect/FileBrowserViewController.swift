//
//  FileBrowserViewController.swift
//  Pitch Perfect
//
//  Created by Karen Tang on 6/21/15.
//  Copyright (c) 2015 Yugen Labs. All rights reserved.
//

import UIKit

class FileBrowserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!

  var files: [String]!
  var dirPath: NSString!
  var fileManager: NSFileManager!
  var recordedAudio: RecordedAudio!

  override func viewDidLoad() {
    super.viewDidLoad()

    // grab files in the documents directory
    dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var error: NSError? = nil
    fileManager = NSFileManager.defaultManager()
    let contents = fileManager.contentsOfDirectoryAtPath(dirPath, error: &error)
    if contents != nil {
      files = contents as [String]
    }

    // link tableview to self
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  override func viewWillDisappear(animated: Bool) {
    tableView.setEditing(false, animated: false)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "effects") {
      let effectsViewController: EffectsViewController = segue.destinationViewController as EffectsViewController
      let data = sender as RecordedAudio
      effectsViewController.recordedAudio = data
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.files.count;
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
    cell.textLabel?.text = self.files[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected item #\(indexPath.row)")
    var selectedFile: NSURL = NSURL.fileURLWithPath(dirPath + "/" + self.files[indexPath.row])!
    println(selectedFile)
    recordedAudio = RecordedAudio(url: selectedFile, title: selectedFile.lastPathComponent!)
    performSegueWithIdentifier("effects", sender: recordedAudio)
  }

  func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    return true
  }

  func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      println("deleting")
      // handle delete (by removing the data from your array and updating the tableview)
      var error: NSError?
      let deleteFilePath = dirPath + "/" + self.files[indexPath.row]
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
