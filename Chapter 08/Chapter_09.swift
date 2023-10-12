/*
 Chapter - 09
 User Interface Design with SwiftUI
 */

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// VStack
struct VContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Header")
                .font(.title)
            Text("First")
                .font(.subheadline)
            Text("Second")
                .font(.subheadline)
        }
    }
}


// HStack
struct HContentView: View {
    var body: some View {
        HStack(alignment: .top) {
            Text("Title")
                .font(.title)
            Text("Content 1")
                .font(.subheadline)
            Text("Item 1")
                .font(.subheadline)
        }
    }
}

// ZStack
let colors: [Color] = [.orange , .red, .green,  .purple , .yellow, .blue]
struct ZContentView: View {
    var body: some View {
        ZStack {
            ForEach(0..<colors.count) {
                Rectangle()
                    .fill(colors[$0])
                    .frame(width: 100, height: 100)
                    .offset(x: CGFloat($0) * 10.0,
                            y: CGFloat($0) * 10.0)
            }
        }
    }
}

// Grid View
struct GContentView: View {
    private var columns: [GridItem] = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]
 
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 16,
                pinnedViews: [.sectionHeaders, .sectionFooters]
            ) {
                Section(header: Text("Section 1").font(.title)) {
                    ForEach(0...10, id: \.self) { index in
                        Color.green
                    }
                }
 
                Section(header: Text("Section 2").font(.title)) {
                    ForEach(11...20, id: \.self) { index in
                        Color.orange
                    }
                }
            }
        }
    }
}

// List
var body: some View {
        List {
            HStack {
                Text("1.").frame(width: 20.0, height: nil, alignment: .leading)
                Text("Name - John Mathew \nAge - 32")
            }
            HStack {
                Text("2.").frame(width: 20.0, height: nil, alignment: .leading)
                Text("Name - Marry Saldom \nAge - 24")
            }
            
        }
    }

// GroupBox
struct HeartGroupBoxStyle: GroupBoxStyle {
func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}
 
struct GBContentView: View {
    var body: some View {
        GroupBox(
            label: Label("Heart Rate - ", systemImage: "heart.fill")
                .foregroundColor(.red)
        ) {
            Text("Your heart rate is 80 BPM.")
        }.groupBoxStyle(HeartGroupBoxStyle())
    }
}

// Sections
struct TaskRow: View {
var body: some View {
        Text("Task Link ")
    }
}
 
struct SContentView: View {
    var body: some View {
        List {
            Section(header: Text("Important Tasks")) {
                TaskRow()
                TaskRow()
            }
            Section(header: Text("Other Tasks")) {
                TaskRow()
                TaskRow()
            }
        }
    }
}

// Navigation
struct NContentView: View {
    @State var username: String = ""
    @State var isPrivate: Bool = true
    @State var notificationsEnabled: Bool = false
    @State private var previewIndex = 0
    var previewOptions = ["Always", "When Unlocked", "Never"]
 
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("PROFILE")) {
                    TextField("Username", text: $username)
                    Toggle(isOn: $isPrivate) {
                        Text("Private Account")
                    }
                }
                
                Section(header: Text("NOTIFICATIONS")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enabled")
                    }
                    Picker(selection: $previewIndex, label: Text("Show Previews")) {
                        ForEach(0 ..< previewOptions.count) {
                            Text(self.previewOptions[$0])
                        }
                    }
                }
                
                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1.1")
                    }
                }
                
                Section {
                    Button(action: {
                        print("Perform an action here...")
                    }) {
                        Text("Reset All Settings")
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

// Shedded Rectangle
struct SRContentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
        .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .square, dash: [15], dashPhase: 2))
        .frame(width: 250, height: 100)
        .foregroundColor(.green)
    }
}

// Square Rectangle
struct MySquare: Shape
{
    func path(in rect: CGRect) -> Path {
        var path = Path()
 
        path.move(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
 
        return path
    }
}
 
struct MSContentView: View {
    var body: some View {
        MySquare()
        .frame(width: 250, height: 250)
    }
}

// Raindrop
struct Raindrop: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width/2, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: rect.size.height), control: CGPoint(x: rect.size.width, y: rect.size.height))
            path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: 0), control: CGPoint(x: 0, y: rect.size.height))
        }
    }
}
 
struct RDContentView: View {
    var body: some View {
        Raindrop()
        .fill(LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .topLeading, endPoint: .bottom))
        .frame(width: 200, height: 200)
    }
}

// Bouncing ball
struct BContentView: View {
    @State private var bounceBall: Bool = false
 
    var body: some View {
        VStack
        {
            Image("ball")
            .resizable()
            .frame(width: 150, height: 150)
            .foregroundColor(.black)
            .clipShape(Circle())
            .animation(Animation.interpolatingSpring(stiffness: 90, damping: 1.5).repeatForever(autoreverses: false))
            .offset(y: bounceBall ? -200 : 200)
            .onTapGesture {
                self.bounceBall.toggle()
            }
        }
    }
}

// Tab Bar
struct TBContentView: View {
    var body: some View {
        TabView {
            Text("The Home Tab")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Home")
                }
            Text("Featured Tab")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Featured")
                }
            Text("The Profile Tab")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .font(.headline)
    }
}

// Split View
struct SVContentView: View {
   
 let requestUrls = ["https://Google.com", "https://bpbonline.com", "https://twitter.com"]
    
    var body: some View {
        
        GeometryReader { geo in
            NavigationView {
                List(self.requestUrls, id: \.self) { url in
                    NavigationLink(destination: RequestDetailView(url: url)) {
                        Text(url)
                    }
                }
                .navigationBarTitle("Links")
                
                Text("Nothing Selected.")
            }
            .padding(.leading, geo.size.height > geo.size.width ? 1 : 0)
        }
 
    }
}
 
// Detail view
struct RequestDetailView: View {
    let url: String
    var body: some View {
        
        Text("Detail view of request with url: \(url).")
    }
}

// Action View
struct AVContentView : View {
    @State private var showAlert = false
    var body: some View {
        Button("Tap to view alert") {
            self.showAlert = true
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Unable to Save Data"),
                message: Text("The connection to the server was lost."),
                primaryButton: .default(
                    Text("Try Again"),
                    action: saveData
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: saveData
                )
            )
        }
    }
    
    func saveData() {
        // Save data code
    }
}

// Action Sheet
struct ASContentView : View {
    @State private var showActionSheet = false
    var body: some View {
        Button("Tap to view action sheet") {
            self.showActionSheet = true
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Resume Workout Recording"),
                        message: Text("Choose a destination for workout data"),
                        buttons: [
                            .cancel(),
                            .destructive(
                                Text("Overwrite Workout"),
                                action: overwrite
                            ),
                            .default(
                                Text("Append Workout"),
                                action: overwrite
                            )
                        ]
            )
        }
    }
    
    func overwrite() {
        // overwrite data code
    }
}















