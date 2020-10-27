//
//  ContentView.swift
//  ML_App
//
//  Created by Vraj Patel on 27/10/20.
//  Copyright © 2020 Vraj Patel. All rights reserved.
//

import SwiftUI
import Firebase
import MLKit

struct ContentView: View {

    @State var name = ""
    @State var show = false
    @State var type : UIImagePickerController.SourceType = .photoLibrary
    @State var data : Data = .init(count: 0)
    var body: some View{

        VStack{

            if self.data.count != 0 {

                Image(uiImage: UIImage(data: data)!)
                .resizable()
                .frame(height: 200)
                .padding()
                Text(name)
            }
            HStack{
                Button(action: {
                    self.type = .photoLibrary
                    self.show.toggle()
                }) {

                    Text("From Photo Library")

                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.black)
                .cornerRadius(10)
            }
        }
        .sheet(isPresented: $show){

            ImagePicker(source: self.type, show: self.$show, name: self.$name, data: self.$data)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ImagePicker : UIViewControllerRepresentable{

    var source : UIImagePickerController.SourceType
    @Binding var show : Bool
    @Binding var name : String
    @Binding var data : Data
    

    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController{

        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.delegate = context.coordinator
        return controller
    }


    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>){


        }

    class Coordinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

        var parent : ImagePicker

        init(parent1: ImagePicker){
            parent = parent1
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

            self.parent.show.toggle()

        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Prepare Input for Image
            let image = info[.originalImage] as! UIImage
        
            
            // Load Model
            guard let manifestPath = Bundle.main.path(forResource: "manifest", ofType: "json",
                inDirectory: "dataSet") else {
                print("Couldn't find manifest.json file")
                return
            }
            let localModel = AutoMLImageLabelerLocalModel(manifestPath: manifestPath)


            // Create Image Labeler from Model
            let options = AutoMLImageLabelerOptions(localModel: localModel)
            options.confidenceThreshold = 0.5
            let imageLaber = ImageLabeler.imageLabeler(options: options)
            
            
            // Run the Image Labeler and Labeled Object
            imageLaber.process(VisionImage(image: image)) { (lables, error) in
                
                if error != nil {
                    print((error?.localizedDescription)!)
                    self.parent.show.toggle()
                }
                
                self.parent.data = image.pngData()!
                self.parent.name = (lables?.first!.text)!
                self.parent.show.toggle()
            }
        }
    }
}
