import java.awt.*;
import javax.swing.*;
import javax.swing.tree.*;
import java.util.concurrent.atomic.AtomicReference;
public class LaunchProbe {
 static int nodes = 0;
 static void inspect(Component c) {
  if(c instanceof JTree t) nodes += t.getRowCount();
  if(c instanceof Container p) for(Component child : p.getComponents()) inspect(child);
 }
 public static void main(String[] args) throws Exception {
  AtomicReference<Throwable> failure = new AtomicReference<>();
  Thread.setDefaultUncaughtExceptionHandler((t,e)->{e.printStackTrace();failure.set(e);});
  Class.forName(args[0]).getMethod("main",String[].class).invoke(null,(Object)new String[0]);
  for(int i=0;i<60;i++) {
   Thread.sleep(500);
   if(failure.get()!=null) System.exit(2);
   final boolean[] ok={false};
   SwingUtilities.invokeAndWait(()->{
    for(Window w:Window.getWindows()) if(w.isShowing() && w.getWidth()>100 && w.getHeight()>100) {
     nodes=0;inspect(w);
     System.out.println("visible="+w.getClass().getName()+" size="+w.getWidth()+"x"+w.getHeight()+" treeRows="+nodes);
     if(nodes>0) ok[0]=true;
    }
   });
   if(ok[0]) { System.out.println("GUI_LAUNCHER_PASS");System.exit(0); }
  }
  throw new AssertionError("No visible populated launcher within 30 seconds");
 }
}
