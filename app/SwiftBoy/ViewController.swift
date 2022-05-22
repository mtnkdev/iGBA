import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let cart = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "01-special.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "02-interrupts.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "03-op sp,hl.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "04-op r,imm.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "05-op rp.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "06-ld r,r.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "07-jr,jp,call,ret,rst.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "08-misc instrs.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "09-op r,r.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "10-bit ops.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "11-op a,(hl).gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "dmg-sound.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "deadeus.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "super-mario-land.gb"))
        let cart = Cartridge(path: #fileLiteral(resourceName: "tetris.gb"))
        
        let title = TitleView(title: cart.title)
        let mmu = MMU(cart)
        let ppu = PPU(mmu)
        let cpu = CPU(mmu)
        let apu = APU(mmu)
        let timer = Timer(mmu)
        let joypad = Joypad(mmu)
        let clock = Clock(mmu, ppu, cpu, apu, timer)
        
        clock.start()
        
        let ui = UIHostingController(rootView: UI(lcd: ppu.view, dPad: joypad.dPad, ab: joypad.ab, startSelect: joypad.startSelect, titleView: title))
        
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ui.view)
        
        ui.view.translatesAutoresizingMaskIntoConstraints = false
        ui.view.topAnchor.constraint(equalTo: view.topAnchor).isActive =  true
        ui.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive =  true
        ui.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
        ui.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive =  true
    }
}

struct TitleView: View {
    @State var title = ""
    
    var body: some View {
        let shearValue = CGFloat(-0.3)
        let shearTransform = CGAffineTransform(a: 1, b: 0, c: shearValue, d: 1, tx: 0, ty: 0)
        
        Text("\(title)  →")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(Rectangle()
                .fill(.white)
                .transformEffect(shearTransform))
    }
        
}

struct UI: View {
    var lcd: LCDBitmapView
    var dPad: DPadView
    var ab: ABView
    var startSelect: StartSelectView
    var titleView: TitleView
    
    var body: some View {
        GeometryReader{ geometry in
            if geometry.size.width > geometry.size.height {
                HStack {
                    dPad
                    VStack {
                        titleView
                        lcd
                    }
                    VStack {
                        Spacer()
                        ab
                        Spacer()
                        startSelect
                    }
                }
            } else {
                VStack{
                    titleView
                    lcd.frame(height: geometry.size.height * 0.5)
                    VStack{
                        HStack {
                            dPad
                            Spacer()
                            ab
                        }
                        startSelect.offset(x: 0, y: 30)
                    }
                    .padding()
                    .frame(height: geometry.size.height * 0.5)
                }
            }
        }
        .background(.black)
    }
}
