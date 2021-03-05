//
//  ReviewCollectionPinpliOnlyImageCell.swift
//  Pinpli
//
//  Created by 남오승 on 2021/03/05.
//

import UIKit

//리뷰 모아보기 핀플리 이미지만 존재 할 경우 셀
class ReviewCollectionPinpliImageCell: BaseTableCell {
 
    lazy var headerWrap:UIView = {
        let view = UIView()
        return view
    }()
    lazy var profileImageWrap:UIView = {
        let view = UIView()
        view.layer.masksToBounds = true //이부분 설정 시 이 안에 addSubView하는 모든 뷰는 이 테두리안에서 논다.
        view.backgroundColor = .blue
        return view
    }()
    lazy var profileImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image 13")
        return image
    }()
    lazy var titleGL:UILabel = {
        let label = UILabel()
        label.text = "일이삼사오육칠팔구십"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        label.colorSetting(r: 31, g: 31, b: 31, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    lazy var ratingGL:UILabel = {
        let label = UILabel()
        label.text = "★ 4/5 점"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        label.colorSetting(r: 31, g: 31, b: 31, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    lazy var writeDateGL:UILabel = {
        let label = UILabel()
        label.text = "2020-01-01"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        label.colorSetting(r: 134, g: 134, b: 134, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    lazy var thumbnailImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image 13")
        return image
    }()
    lazy var bottomLine:UIView = {
        let view = UIView()
        view.setBackgroundColor(r: 242, g: 242, b: 242, alpha: 1)
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func addContentView() {
        addSubview(headerWrap)
        headerWrap.addSubview(profileImageWrap)
        profileImageWrap.addSubview(profileImage)
        headerWrap.addSubview(titleGL)
        headerWrap.addSubview(ratingGL)
        headerWrap.addSubview(writeDateGL)
        addSubview(thumbnailImage)
        addSubview(bottomLine)
    }
    
    private func autoLayout() {
        headerWrap.snp.makeConstraints { (make) in
            let topRatio = constraintRatio(direction: .top, standardSize: 20)
            let height = aspectRatio(standardSize: 20)
            make.height.equalTo(height)
            make.top.equalTo(topRatio)
            make.leading.equalTo(22)
            make.trailing.equalTo(-22)
        }
        profileImageWrap.snp.makeConstraints { (make) in
            let width = aspectRatio(standardSize: 20)
            profileImageWrap.layer.cornerRadius = width/2
            make.width.equalTo(width)
            make.leading.top.bottom.equalToSuperview()
        }
        profileImage.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        titleGL.snp.makeConstraints { (make) in
            let fontSize = aspectRatio(standardSize: 14)
            let leftRatio = constraintRatio(direction: .left, standardSize: 8)
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(profileImageWrap.snp.trailing).offset(leftRatio)
            titleGL.font = titleGL.font.withSize(fontSize)
        }
        ratingGL.snp.makeConstraints { (make) in
            let fontSize = aspectRatio(standardSize: 14)
            let leftRatio = constraintRatio(direction: .left, standardSize: 4)
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(titleGL.snp.trailing).offset(leftRatio)
            ratingGL.font = ratingGL.font.withSize(fontSize)
        }
        writeDateGL.snp.makeConstraints { (make) in
            let fontSize = aspectRatio(standardSize: 12)
            make.top.trailing.bottom.equalToSuperview()
            writeDateGL.font = writeDateGL.font.withSize(fontSize)
        }
        thumbnailImage.snp.makeConstraints { (make) in
            let height = currentViewSize.width - 44
            let topRatio = constraintRatio(direction: .top, standardSize: 20)
            make.leading.equalTo(22)
            make.trailing.equalTo(-22)
            make.height.equalTo(height)
            make.top.equalTo(headerWrap.snp.bottom).offset(topRatio)
        }
        bottomLine.snp.makeConstraints { (make) in
            let height = aspectRatio(standardSize: 10)
            make.height.equalTo(height)
            let topRatio = constraintRatio(direction: .top, standardSize: 20)
            make.top.equalTo(thumbnailImage.snp.bottom).offset(topRatio)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
