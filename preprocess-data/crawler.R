library(rvest)
library(htmltools)
library(xml2)
# library(magrittr)
# library(jsonlite)

startid = 57135
endid = 103491 # 103491 # 2022.12.7
count = 0

if (!dir.exists("data")) {
  dir.create("data")
}

for (idx in startid:endid) {
  link = "http://m.myhome.tsinghua.edu.cn/weixin/weixin_advice.aspx?id="
  link = paste(link, idx, sep="")
  tryCatch(expr = {
      html = read_html(link)
      title =  html %>% html_nodes("#weixin_adviceCtrl1_lbltitle") %>% html_text()
      title = trimws(title)
      if (nchar(title) > 0) { ### 说明是有内容的
        outpth = paste("data/", idx, ".html", sep="")
        write_xml(html, outpth);
        count = count + 1
        if (count %% 50 == 0) {
          print(paste('[', count, "] id:", idx, title));
          Sys.sleep(1)
        }
      }
    }, error = function(cond) {
            message(paste("Error occurs when reading URL:", link))
            message("Here's the original error message:")
            message(paste(cond, "\n"))
            # Choose a return value in case of error
            return(NA)
    }, finally = {
      
    }
  )
  
  
}




# 
# write_html(html, "data/test1.html")

