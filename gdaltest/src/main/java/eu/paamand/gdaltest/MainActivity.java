package eu.paamand.gdaltest;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.Toast;

import org.gdal.gdal.gdal;
import org.gdal.osr.CoordinateTransformation;
import org.gdal.osr.SpatialReference;
import org.gdal.osr.osr;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        String versionNfo = gdal.VersionInfo();
        Toast.makeText(this, versionNfo, Toast.LENGTH_LONG).show();

        String EPSG4326 = "GEOGCS[\"WGS 84\",\n" +
                "    DATUM[\"WGS_1984\",\n" +
                "        SPHEROID[\"WGS 84\",6378137,298.257223563,\n" +
                "            AUTHORITY[\"EPSG\",\"7030\"]],\n" +
                "        AUTHORITY[\"EPSG\",\"6326\"]],\n" +
                "    PRIMEM[\"Greenwich\",0,\n" +
                "        AUTHORITY[\"EPSG\",\"8901\"]],\n" +
                "    UNIT[\"degree\",0.0174532925199433,\n" +
                "        AUTHORITY[\"EPSG\",\"9122\"]],\n" +
                "    AUTHORITY[\"EPSG\",\"4326\"]]";
        String proj4 = "+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs ";
        SpatialReference utmSpatialReference = new SpatialReference();
        utmSpatialReference.ImportFromProj4(proj4);
        CoordinateTransformation trsform = osr.CreateCoordinateTransformation(
                new SpatialReference(EPSG4326), //LatLng
                utmSpatialReference);
        double[] SWutm = trsform.TransformPoint(12.479638, 55.961439);
        Toast.makeText(this, Double.toString(SWutm[0]), Toast.LENGTH_LONG).show();

        setContentView(R.layout.activity_main);
    }
}
