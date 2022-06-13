//
//  NoteTableViewCell.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

	@IBOutlet weak var imageViewKindOfNote: UIImageView!
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelCreatingNoteDate: UILabel!
	@IBOutlet weak var labelNoteShortDesc: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
