public class NativePlatformsProbe {
 public static void main(String[] args) throws Exception {
  Object major=Class.forName("org.bytedeco.opencv.global.opencv_core").getMethod("getVersionMajor").invoke(null);
  if(((Number)major).intValue()!=4) throw new AssertionError("Unexpected OpenCV version");
  Object sum=Class.forName("org.bytedeco.openblas.global.openblas").getMethod("cblas_dasum",int.class,double[].class,int.class).invoke(null,3,new double[]{-1,2,-3},1);
  if(((Number)sum).doubleValue()!=6.0) throw new AssertionError("Invalid OpenBLAS sum");
  System.out.println("OPENCV_OPENBLAS_NATIVE_PASS major="+major+" absoluteSum="+sum);
 }
}
