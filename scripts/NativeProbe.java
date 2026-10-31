public class NativeProbe {
 public static void main(String[] args) throws Exception {
  Class<?> type=Class.forName("org.bytedeco.ffmpeg.global.avcodec");
  Object version=type.getMethod("avcodec_version").invoke(null);
  if(((Number)version).intValue()<=0) throw new AssertionError("Invalid avcodec version");
  System.out.println("FFMPEG_NATIVE_PASS avcodec_version="+version);
 }
}
