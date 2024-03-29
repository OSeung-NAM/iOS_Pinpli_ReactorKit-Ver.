//
//  MyInfoVC.swift
//  Pinpli
//
//  Created by 남오승 on 2020/12/25.
//

import UIKit
import SnapKit
import Photos
import TLPhotoPicker
import Mantis
import RxSwift

//내정보
class MyPageVC:BaseViewController {
    
    let myPageLoginView = MyPageLoginView() //로그인 했을 시
    let myPageLogoutView = MyPageLogoutView() //로그인 안 했을 시
    var selectedAssets = [TLPHAsset]()
    var image:UIImage?
    var croppedImage:UIImage?
    var imageManager = PHCachingImageManager() //앨범에서 사진 받아오기 위한 객체
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view = myPageLogoutView
        view = myPageLoginView
        
        /* UIEvent */
        let isProfileEditEvent = myPageLoginView.profileEditEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isNickNameEditEvent = myPageLoginView.nickNameEditEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isMyInfoEvent = myPageLoginView.myInfoEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        
        let isMyReviewEvent = myPageLoginView.myReviewEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isBlackListEvent = myPageLoginView.blackListEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isQuestionEvent = myPageLoginView.questionEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isCommonSettingsEvent = myPageLoginView.commonSettngsEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        
        let isServiceTermsEvent = myPageLoginView.serviceTermsEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isPrivacyTermsEvent = myPageLoginView.privacyTermsEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isFaqEvent = myPageLoginView.faqEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isNoticeEvent = myPageLoginView.noticeEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        
        let isQnaDeleteEvent = myPageLoginView.qnaDeleteEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        let isQuestionWriteEvent = myPageLoginView.questionWriteEvent.filter{$0}.observeOn(MainScheduler.asyncInstance)
        
        isProfileEditEvent.bind{[weak self] result in
            self?.albumCallEvent()
        }.disposed(by: disposeBag)

        isNickNameEditEvent.bind{[weak self] result in
            let nickNameEditVC = NickNameEditVC()
            nickNameEditVC.modalPresentationStyle = .fullScreen
            self?.present(nickNameEditVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        isMyInfoEvent.bind{[weak self] result in
            let myInfoVC = MyInfoVC()
            self?.navigationController?.pushViewController(myInfoVC, animated: true)
        }.disposed(by: disposeBag)
        
        isMyReviewEvent.bind{[weak self] result in
            self?.myReviewEvent()
        }.disposed(by: disposeBag)
        
        isBlackListEvent.bind{[weak self] result in
            self?.blackListEvent()
        }.disposed(by: disposeBag)
        
        isQuestionEvent.bind{[weak self] result in
            self?.questionEvent()
        }.disposed(by: disposeBag)
        
        isCommonSettingsEvent.bind{[weak self] result in
            self?.commonSettingsEvent()
        }.disposed(by: disposeBag)
        
        isServiceTermsEvent.bind{[weak self] result in
            self?.commonSetingsMenuEvent(index: 0)
        }.disposed(by: disposeBag)
        isPrivacyTermsEvent.bind{[weak self] result in
            self?.commonSetingsMenuEvent(index: 1)
        }.disposed(by: disposeBag)
        isFaqEvent.bind{[weak self] result in
            self?.commonSetingsMenuEvent(index: 2)
        }.disposed(by: disposeBag)
        isNoticeEvent.bind{[weak self] result in
            self?.commonSetingsMenuEvent(index: 3)
        }.disposed(by: disposeBag)
        
        isQnaDeleteEvent.bind{[weak self] result in
            self?.qnaDeleteAlert()
        }.disposed(by: disposeBag)
        
        isQuestionWriteEvent.bind{[weak self] result in
            let questionWriteVC = QuestionWriteVC()
            questionWriteVC.modalPresentationStyle = .fullScreen
            self?.present(questionWriteVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        /* */

    }
    
    func albumCallEvent() {
        let optionMenu = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        print(PHAuthorizationStatus.authorized)
        let albumAction = UIAlertAction(title: "앨범에서 사진 가져오기", style: .default, handler:
        {
            
            [weak self] (alert: UIAlertAction!) -> Void in
            self?.albumMoveEvent()
            PHPhotoLibrary.requestAuthorization({ (granted) in
                if (granted == PHAuthorizationStatus.authorized) { //접근 허용
                    DispatchQueue.main.async {
//                        guard let photoMultiImagePOP = albumStoryBoard.instantiateViewController(withIdentifier: "PhotoMultiImagePOP") as? PhotoMultiImagePOP else {
//                            return
//                        }
//                            self.selectedPhotoImage.reverse()
//                            self.selectedPhotoMediaId.reverse()
//                        photoMultiImagePOP.selectedPhotoImage = self.selectedPhotoImage
//                        photoMultiImagePOP.callingView = self as Any
//                        photoMultiImagePOP.selectedMediaId = self.selectedPhotoMediaId
//                            photoMultiImagePOP.updateSelectedPhotoImage = self.updateSelectedPhotoImage
//                        photoMultiImagePOP.updateUrlList = self.updateUrlList
//                        photoMultiImagePOP.updateAlbumList = self.updateAlbumList
//                        self.present(photoMultiImagePOP, animated: true, completion: nil)
                    }
                } else {
                  DispatchQueue.main.async {
                        let alert = UIAlertController(title: "'설정 > Rippler > 앨범 권한 ON'\n앨범 접근 권한을 켜주세요 :)", message: "\n앨범 권한 허용해야 사진을 등록 할 수 있어요😝권한 설정하러 가볼까요~?", preferredStyle: .alert)
                                             // Change font and color of title

                        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")

                        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13,weight: UIFont.Weight.regular),NSAttributedString.Key.foregroundColor :UIColor.black]), forKey: "attributedMessage")

                        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView

                        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (action:UIAlertAction!) in
                            if let settingUrl = URL(string:UIApplication.openSettingsURLString) {
                                           UIApplication.shared.open(settingUrl)
                            } else {
                                print("Setting URL invalid")
                            }
                        }))

                        subview.backgroundColor = UIColor.white

                    self?.present(alert, animated: true)
                    }

                    // Doing
                }
            })

        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
   
        optionMenu.addAction(albumAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)

    }
    
    //엘범 호출하는 이벤트
    func albumMoveEvent() {
        let albumStatus = PHPhotoLibrary.authorizationStatus()
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);

        if cameraStatus == .authorized {
            print("카메라 인증")
        }
        
        if albumStatus == .authorized {
            print("앨범 인증")
        }
        if cameraStatus == .authorized {// 권한 설정이 되었을 때 처리
            if albumStatus == .authorized { // 권한 설정이 되었을 때 처리
                photoMove()
            } else if albumStatus == .denied  { // 권한 설정이 거부 되었을 때
                accessDeniedAlert(flag: true)
            } else if albumStatus == .notDetermined {
                // 결정 안됨 (아래와 같이 시스템 팝업 띄움)
                PHPhotoLibrary.requestAuthorization({ [weak self] (result:PHAuthorizationStatus) in
                    switch result{
                    case .authorized: // 권한 설정이 되었을 때 처리
                        DispatchQueue.main.async {
                            self?.photoMove()
                        }
                        break
                    case .denied: // 권한 설정이 거부 되었을 때
                        DispatchQueue.main.async {
                            self?.accessDeniedAlert(flag: true)
                        }
                        break
                    default:
                        break
                    }
                })
            }
        } else if cameraStatus == .denied {// 권한 설정이 거부 되었을 때
            accessDeniedAlert(flag: false)
        }else if cameraStatus == .notDetermined { //초기 물음
            // 결정 안됨 (아래와 같이 시스템 알럿 띄움)
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
                if response { // 권한 설정이 되었을 때 처리
                    if albumStatus == .authorized { // 권한 설정이 되었을 때 처리
                        self?.photoMove()
                    } else if albumStatus == .denied  { // 권한 설정이 거부 되었을 때
                        self?.accessDeniedAlert(flag: true)
                    } else if albumStatus == .notDetermined {
                        // 결정 안됨 (아래와 같이 시스템 팝업 띄움)
                        PHPhotoLibrary.requestAuthorization({ [weak self] (result:PHAuthorizationStatus) in
                            switch result{
                            case .authorized: // 권한 설정이 되었을 때 처리
                                DispatchQueue.main.async {
                                    self?.photoMove()
                                }
                                break
                            case .denied: // 권한 설정이 거부 되었을 때
                                DispatchQueue.main.async {
                                    self?.accessDeniedAlert(flag: true)
                                }
                                break
                            default:
                                break
                            }
                        })
                    }
                } else { // 권한 설정이 거부 되었을 때
                    DispatchQueue.main.async {
                        self?.accessDeniedAlert(flag: false)
                    }
                }
            }
        }
    }
    
    //앨범 + 카메라 접근
    func photoMove() {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        var configure = TLPhotosPickerConfigure() //커스텀
        
        configure.cancelTitle = "취소"
        configure.doneTitle = "완료"
        configure.emptyMessage = "앨범이 없습니다."
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        configure.allowedLivePhotos = false
        configure.singleSelectedMode = true
        configure.tapHereToChange = "앨범 변경"
        configure.selectedColor = UIColor(red: 253/255, green: 177/255, blue: 75/255, alpha: 1.0)
        viewController.configure = configure
        
        present(viewController, animated: true, completion: nil)
    }
    
    func accessDeniedAlert(flag:Bool) {
        var alert = UIAlertController(title: "고객님의 원활한 '적셔' \n서비스 이용을 위해\n아래의 앨범 접근 권한 허용이 필요합니다.", message: "\n프로필 설정 시 이미지 첨부", preferredStyle: .alert)
        if !flag {
            alert = UIAlertController(title: "고객님의 원활한 '적셔' \n서비스 이용을 위해\n아래의 카메라 접근 권한 허용이 필요합니다.", message: "\n프로필 설정 시 이미지 첨부", preferredStyle: .alert)
        }
        
        // Change font and color of title
        
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13,weight: UIFont.Weight.regular),NSAttributedString.Key.foregroundColor :UIColor.black]), forKey: "attributedMessage")
        
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (action:UIAlertAction!) in
            if let settingUrl = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingUrl)
            } else {
                print("Setting URL invalid")
            }
        }))
        
        subview.backgroundColor = UIColor.white
        
      
    }
    
    //내 리뷰 탭
    func myReviewEvent() {
        myPageLoginView.contentsSetting(tabGubun: 0)
    }
    
    //블랙리스트 탭
    func blackListEvent() {
        myPageLoginView.contentsSetting(tabGubun: 1)
    }
    
    //1:1문의 탭
    func questionEvent() {
        myPageLoginView.contentsSetting(tabGubun: 2)
    }
    
    //일반 설정 탭
    func commonSettingsEvent() {
        myPageLoginView.contentsSetting(tabGubun: 3)
    }
    
    //일반설정 메뉴 이동
    func commonSetingsMenuEvent(index:Int) {
        if index == 0 { //서비스 이용약관
            let termsVC = TermsVC()
            termsVC.termsGubun = 0
            termsVC.modalPresentationStyle = .overCurrentContext
            present(termsVC, animated: false, completion: nil)
        }else if index == 1 { //개인정보 처리방침
            let termsVC = TermsVC()
            termsVC.termsGubun = 1
            termsVC.modalPresentationStyle = .overCurrentContext
            present(termsVC, animated: false, completion: nil)
        }else if index == 2 { //자주하는 질문
            let noticeFAQVC = NoticeFAQVC()
            noticeFAQVC.gubun = false
            navigationController?.pushViewController(noticeFAQVC, animated: true)
        }else { //공지사항
            let noticeFAQVC = NoticeFAQVC()
            noticeFAQVC.gubun = true
            navigationController?.pushViewController(noticeFAQVC, animated: true)
        }
    }
    
    //qna삭제 팝업
    func qnaDeleteAlert() {
        let alert = UIAlertController(title: "작성한 문의를 삭제할까요?", message: "\n삭제하게 된다면 소중한 문의를\n다시 찾아볼 수 없어요 :(", preferredStyle: .alert)

        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
    
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13,weight: UIFont.Weight.regular),NSAttributedString.Key.foregroundColor :UIColor.black]), forKey: "attributedMessage")

        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        alert.addAction(UIAlertAction(title: "삭제하기", style: .default, handler: { [weak self] (action:UIAlertAction!) in
            self?.myPageLoginView.questionView.reviewDeletePop()
        }))
        alert.addAction(UIAlertAction(title: "취소하기", style: .cancel, handler: { (action:UIAlertAction!) in }))
  
        subview.backgroundColor = UIColor.white
        present(alert, animated: true)
    }
}


//이미지 호출 후 크롭하기위한 extension
extension MyPageVC: TLPhotosPickerViewControllerDelegate, CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage) {
//        if let reactor = self.reactor {
            croppedImage = cropped
            print(cropped)
        myPageLoginView.profileImage.image = cropped
//            reactor.action.onNext(.imageUpload(profileImage: cropped))
//        }
    }
    
    //TLPhotosPickerViewControllerDelegate
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        selectedAssets = withTLPHAssets
        return true
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        if withPHAssets.count > 0 {
            self.imageManager.requestImage(for: withPHAssets[0], targetSize: .zero, contentMode: .aspectFill, options: nil, resultHandler: { image, info in
                
                //고품질 사진 확인
                if let complete = (info?["PHImageResultIsDegradedKey"] as? Bool) {
                    if !complete {
                        if let image = image {
                            let cropViewController = Mantis.cropViewController(image: image)
                            cropViewController.delegate = self
                            cropViewController.modalPresentationStyle = .fullScreen
                            self.present(cropViewController, animated: true)
                        }
                    }
                }
            })
        }
    }
    
    func photoPickerDidCancel() {
        // cancel
    }
    
    func dismissComplete() {
        // picker viewcontroller dismiss completion
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        //Custom Rules & Display
        //You can decide in which case the selection of the cell could be forbidden.
        return true
    }
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        // exceed max selection
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        // handle denied albums permissions case
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        // handle denied camera permissions case
    }
}
