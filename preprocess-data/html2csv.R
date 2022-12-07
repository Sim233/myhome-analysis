library(rvest)
library(xml2)

files = list.files("data", full.names = T)
titles = c(); times = c(); ipaddrs = c(); contents = c(); 
answers = c(); answerBys = c(); answerTimes = c(); replyCounts = c(); replyContents = c()

getId = function(x) {
    as.integer(substring(x, 6, nchar(x)-5))
}

ids = sort(sapply(files, getId))
print(ids[1:50])

for (i in 1:length(files)) {
    f = paste("data/", ids[i], ".html", sep="")
    html = read_html(f)
    title =  html %>% html_nodes("#weixin_adviceCtrl1_lbltitle") %>% html_text() %>% trimws()
    time = html %>% html_nodes("#weixin_adviceCtrl1_lbltime") %>% html_text() %>% trimws() 
    ipaddr = html %>% html_nodes("#weixin_adviceCtrl1_lbllaiyuan") %>% html_text() %>% trimws() 
    content = html %>% html_nodes("#weixin_adviceCtrl1_lblContent") %>% html_text() %>% trimws() 
    answer = html %>% html_nodes("#weixin_adviceCtrl1_weixin_advice_dfCtrl1_Repeater1_ctl00_lblContent") %>% html_text() %>% trimws() 
    if (length(answer) > 0) {
        answerBy = html %>% html_nodes("#weixin_adviceCtrl1_weixin_advice_dfCtrl1_Repeater1_ctl00_lblOperator_ID2") %>% html_text() %>% trimws() 
        answerTime = html %>% html_nodes("#weixin_adviceCtrl1_weixin_advice_dfCtrl1_Repeater1_ctl00_lblFeedback_Time") %>% html_text() %>% trimws() 
    } else {
        answer = ""; answerBy = ""; answerTime = ""
    }
    replyCountStr = html %>% html_nodes("#weixin_adviceCtrl1_weixin_advice_hfCtrl1_lblcount") %>% html_text() %>% trimws()
    replyCount = as.integer(substring(replyCountStr, 1, nchar(replyCountStr)-1))
    replyContent = ""
    if (replyCount > 0) {
        for (i in 1:min(replyCount,9)) {
            str = html %>% html_nodes(paste("#weixin_adviceCtrl1_weixin_advice_hfCtrl1_Repeater1_ctl0",i,"_lbladvice", sep="")) %>% html_text() %>% trimws();
            replyContent = paste(replyContent, str)
        }
    }
    replyContent = trimws(replyContent)
    replys = html %>% html_nodes("#weixin_adviceCtrl1_weixin_advice_hfCtrl1_Repeater1_ctl02_lbladvice")
    
    if (i %% 5000 == 0) {
        print(paste("===============",i,"================"))
        print(f)
        print(title)
        print(time)
        print(ipaddr)
        print(content)
        print(answer)
        print(answerBy)
        print(answerTime)
        print(replyCount)
        print(replyContent)
    }
    titles = c(titles, title); times = c(times, time); ipaddrs = c(ipaddrs, ipaddr); contents = c(contents, content); 
    answers = c(answers, answer); answerBys = c(answerBys, answerBy); answerTimes = c(answerTimes, answerTime); 
    replyCounts = c(replyCounts, replyCount); replyContents = c(replyContents, replyContent)


}

df = data.frame(
    filePath = files,
    title = titles,
    time = times,
    ipaddr = ipaddrs,
    content = contents,
    answer = answers,
    answerBy = answerBys,
    answerTime = answerTimes,
    replyCount = replyCounts,
    replyContent = replyContents
)

write.csv(df, file = "jiayuan.csv")