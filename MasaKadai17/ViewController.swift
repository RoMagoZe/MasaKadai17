//
//  ViewController.swift
//  MasaKadai17
//
//  Created by Mina on 2023/07/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var items = Fruits.defaultItems
    private let checkMark = UIImage(named: "check-mark")
    private var selectedIndexPath: IndexPath?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let navigationController = segue.destination as? UINavigationController,
              let secondViewController = navigationController.topViewController as? SecondViewController else {
            return
        }

        if segue.identifier == "addSegue" {
            prepareForAddSegue(secondVC: secondViewController)
        } else if segue.identifier == "AccessorySegue" {
            prepareForAccessorySegue(secondVC: secondViewController)
        }
    }

    private func prepareForAddSegue(secondVC: SecondViewController) {

        secondVC.mode = .add(AddParameter(
            cancel: { [weak self] in
                self?.dismiss(animated: true)
            },
            save: { [weak self] newName in
                self?.items.append((newName, false))
                self?.tableView.reloadData()

                self?.dismiss(animated: true)
            })
        )
    }

    private func prepareForAccessorySegue(secondVC: SecondViewController) {
        guard let indexPath = selectedIndexPath else { return }

        secondVC.mode = .edit(EditParameter(
            name: items[indexPath.row].0,
            cancel: {[weak self] in
                self?.dismiss(animated: true)
            },
            save: {[weak self] newName in
                guard let strongSelf = self else { return }

                strongSelf.items[indexPath.row] = (newName, strongSelf.items[indexPath.row].1)
                strongSelf.tableView.reloadData()

                strongSelf.dismiss(animated: true)
            })
        )
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.0
        cell.imageView?.image = item.1 ? checkMark : nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        items[indexPath.row].1.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "AccessorySegue", sender: nil)
    }

    // SwiftiLintの警告回避で改行してる
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
