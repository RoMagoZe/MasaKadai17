//
//  SecondViewController.swift
//  MasaKadai17
//
//  Created by Mina on 2023/07/24.
//

import UIKit

struct AddParameter {
    let cancel: () -> Void
    let save: (String) -> Void
}

struct EditParameter {
    let name: String
    let cancel: () -> Void
    let save: (String) -> Void
}

class SecondViewController: UIViewController {

    // Nesting Violation: Types should be nested at most 1 level deep (nesting)を回避
    // structをenumの外に移動
    enum Mode {
        case add(AddParameter)
        case edit(EditParameter)
    }

    @IBOutlet private weak var inputTextField: UITextField!

    var mode: Mode?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let mode = mode else { return }

        switch mode {
        case .add:
            inputTextField.text = ""
        case .edit(let parameter):
            inputTextField.text = parameter.name
        }
    }

    @IBAction func didTapCancel(_ sender: Any) {
        guard let mode = mode else { return }

        switch mode {
        case .add(let parameter):
            parameter.cancel()
        case .edit(let parameter):
            parameter.cancel()
        }
    }

    @IBAction func didTapSave(_ sender: Any) {
        guard let mode = mode else { return }

        switch mode {
        case .add(let parameter):
            parameter.save(inputTextField.text ?? "")
        case .edit(let parameter):
            parameter.save(inputTextField.text ?? "")
        }
    }
}
