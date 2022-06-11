//
//  NoteTableViewCell.swift
//  TakeANote
//
//  Created by BERAT ALTUNTAŞ on 11.06.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

	@IBOutlet private weak var imageViewKindOfNote: UIImageView!
	@IBOutlet private weak var labelTitle: UILabel!
	@IBOutlet private weak var labelTakingNoteDate: UILabel!
	@IBOutlet private weak var labelNoteShortDesc: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
