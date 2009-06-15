/*
 * Automatically generated by jrpcgen 1.0.5 on 5/17/08 10:31 PM
 * jrpcgen is part of the "Remote Tea" ONC/RPC package for Java
 * See http://acplt.org/ks/remotetea.html for details
 */
package bamboo.dht;
import org.acplt.oncrpc.*;
import java.io.IOException;

public class bamboo_get_result implements XdrAble {
    public bamboo_get_value [] values;
    public bamboo_placemark placemark;

    public bamboo_get_result() {
    }

    public bamboo_get_result(XdrDecodingStream xdr)
           throws OncRpcException, IOException {
        xdrDecode(xdr);
    }

    public void xdrEncode(XdrEncodingStream xdr)
           throws OncRpcException, IOException {
        { int $size = values.length; xdr.xdrEncodeInt($size); for ( int $idx = 0; $idx < $size; ++$idx ) { values[$idx].xdrEncode(xdr); } }
        placemark.xdrEncode(xdr);
    }

    public void xdrDecode(XdrDecodingStream xdr)
           throws OncRpcException, IOException {
        { int $size = xdr.xdrDecodeInt(); values = new bamboo_get_value[$size]; for ( int $idx = 0; $idx < $size; ++$idx ) { values[$idx] = new bamboo_get_value(xdr); } }
        placemark = new bamboo_placemark(xdr);
    }

}
// End of bamboo_get_result.java
