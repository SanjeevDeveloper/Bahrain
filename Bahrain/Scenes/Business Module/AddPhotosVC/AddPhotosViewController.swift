

import UIKit

protocol AddPhotosDisplayLogic: class
{
    func displayResponse(viewModel: AddPhotos.ViewModel)
    func galleryUpdated()
}

class AddPhotosViewController: UIViewController, AddPhotosDisplayLogic
{
    var interactor: AddPhotosBusinessLogic?
    var router: (NSObjectProtocol & AddPhotosRoutingLogic & AddPhotosDataPassing)?
    
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = AddPhotosInteractor()
        let presenter = AddPhotosPresenter()
        let router = AddPhotosRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    @IBOutlet weak var addPhotosCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var addPhotoLabel: UILabelFontSize!
    @IBOutlet weak var addView: UIView!
    var addPhotosArray = [AddPhotos.ViewModel.tableCellData]()
    var delegate:movePageController!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        applyFontAndColor()
        if self.addPhotosArray.count == 1 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        doneButton.backgroundColor = appBarThemeColor
        doneButton.tintColor = appBtnWhiteColor
        
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: PhotosSceneText.photosSceneTitle.rawValue), onVC: self)
        
        addPhotoLabel.text = localizedTextFor(key: PhotosSceneText.photosSceneAddPhotoLabel.rawValue)
        
        if appDelegateObj.isPageControlActive {
            doneButton.setTitle(localizedTextFor(key:GeneralText.Continue.rawValue), for: .normal)
        }else {
            doneButton.setTitle(localizedTextFor(key: PhotosSceneText.photosSceneDoneButton.rawValue), for: .normal)
        }
    }
    
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.hitGetBusinessGalleryApi()
    }
    
    // MARK: Button Actions
    
    @IBAction func crossButton(_ sender: UIButton) {
        var view:UIView = sender
        repeat { view = view.superview! } while !(view is UICollectionViewCell)
        let cell = view as! AddPhotosCollectionViewCell
        let indexPath = addPhotosCollectionView.indexPath(for:cell)!
        
        addPhotosArray.remove(at: indexPath.item)
        addPhotosCollectionView.deleteItems(at: [indexPath])
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        let lastIndex = addPhotosArray.count - 1
        var requestArray = addPhotosArray
        requestArray.remove(at: lastIndex)
        let requestObj = AddPhotos.Request(imageReq: requestArray)
        interactor?.hituploadBusinessGalleryApi(request: requestObj)
    }
    
    // MARK: Display Response
    func displayResponse(viewModel: AddPhotos.ViewModel) {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
            
        else {
            addPhotosArray = viewModel.tableArray
            let image = #imageLiteral(resourceName: "AddIcon")
            let obj = AddPhotos.ViewModel.tableCellData(imageUrl: nil, image: image)
            addPhotosArray.append(obj)
            if self.addPhotosArray.count == 1 {
                addView.isHidden = false
            }
            else {
                addView.isHidden = true
            }
            addPhotosCollectionView.reloadData()
        }
        
    }
    
    // MARK: GalleryUpdated
    func galleryUpdated() {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: PhotosSceneText.PhotosSceneImageUploadedSuccessfully.rawValue), type: .success)
        
        if appDelegateObj.isPageControlActive {
            delegate.moveToNextPage()
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionPlusBtn(_ sender: Any) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
}

// MARK: UICollectionViewDelegate

extension AddPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return addPhotosArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! AddPhotosCollectionViewCell
        let obj = addPhotosArray[indexPath.item]
        if let imageUrl = obj.imageUrl {
            let image = imageUrl
            let imageCompleteUrl = Configurator().imageBaseUrl + image
            
            cell.galleryImage.sd_setImage(with: URL(string: imageCompleteUrl), completed: nil)
        }
        else{
            cell.galleryImage.image = obj.image
        }
        if (indexPath.row == addPhotosArray.count-1){
            cell.crossImageButton.isHidden = true
            cell.galleryImage.contentMode = .scaleAspectFit
        }else{
            cell.crossImageButton.isHidden = false
            cell.galleryImage.contentMode = .scaleToFill
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if(indexPath.item == addPhotosArray.count-1){
            imagePicker(collectionView)
        }
        
    }
    
    func imagePicker(_ sender: Any) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UICollectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        let requiredWidth = (width / 3) - 10
        return CGSize(width: requiredWidth, height: 100)
    }
}

// MARK: CustomImagePickerProtocol

extension AddPhotosViewController : CustomImagePickerProtocol {
    
    func didFinishPickingImage(image:UIImage) {
        
        let obj = AddPhotos.ViewModel.tableCellData(imageUrl: nil, image: image)
        addPhotosArray.insert(obj, at: 0)
        addPhotosCollectionView.reloadData()
    }
    
    func didCancelPickingImage() {
        
    }
}
