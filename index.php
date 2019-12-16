<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>PIE CHART</title>
    <style>
      body{
        background-color: #f9e9d3;
      }
      canvas{
        /* background-color: #fff; */
      }
    </style>
  </head>
  <body>
    <div id="wrapper1"></div>
    <a href='#' id="download1">Download as image</a>
    <a href='#' id="base64">image base64</a>
    <!-- <div id="wrapper2"></div>
    <a href='#' id="download2">Download as image</a> -->
  </body>
  <footer>
    <script src="jquery.min.js" charset="utf-8"></script>
    <script src="easeljs-0.8.2.min.js" charset="utf-8"></script>
    <script src="piechart.min.js" charset="utf-8"></script>
    <script type="text/javascript">
    var chart1;
      $(document).ready(function(){
        $('#wrapper1').piechart()
        // $('#wrapper2').piechart()
        // $('#download2').click(function(){
        //   $('#wrapper2').data('webchart').download(this,'test2.png','image/png')
        // })
        // MODIFY DATA OR ACTION
        chart1 = $('#wrapper1').data('piechart')
        chart1.setData([.2,0.7,1])
        $('#download1').click(function(){
          chart1.download(this,'test1.jpg','image/jpeg', 1.0)
        })
        $('#base64').click(function(){
          console.log(chart1.get64())
        })

      })
    </script>
  </footer>
</html>
