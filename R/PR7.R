source("PR2.init.R")
library(gvlma)

########
## START
########


### Are subjects becoming more different withing one trajectory
### Are sessions becoming incresingly more different each other

# Average distance of each face from the faces submitted in the same round in other exhibitions

# Facets DSE.PUB.PREV by SESSION
################################
p <- ggplot(pr, aes(round, group=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.1, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.2, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.3, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.4, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.5, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.6, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.7, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.8, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.9, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.10, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.11, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.12, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.13, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.14, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.15, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.16, colour=com))
p <- p + ggtitle("Distance between current submissions of a session\n and faces published in the previous round in other sessions") + xlab("Round") + ylab("Face difference") # + theme(panel.background = element_blank())
p <- p + facet_wrap(~session, ncol=4)
p
ggsave(file="./img/ses2ses/dse.pub.prev_facet_session.jpg")


# Facets DSE.SUB.CURR by SESSION
################################
p <- ggplot(pr, aes(round, group=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.1, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.2, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.3, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.4, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.5, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.6, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.7, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.8, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.9, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.10, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.11, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.12, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.13, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.14, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.15, colour=com))
p <- p + geom_smooth(aes(y = dse.sub.curr.16, colour=com))
p <- p + ggtitle("Between session distance of submissions at the same round") + xlab("Round") + ylab("Face difference") # + theme(panel.background = element_blank())
p <- p + facet_wrap(~session, ncol=4)
p
ggsave(file="./img/ses2ses/dse.sub.curr_facet_session.jpg")

# Facets DSE.PUB.CUM by SESSION
################################
p <- ggplot(pr, aes(round, group=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.1, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.2, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.3, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.4, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.5, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.6, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.7, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.8, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.9, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.10, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.11, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.12, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.13, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.14, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.15, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.cum.16, colour=com))
p <- p + ggtitle("Distance between current submissions of a session\n and **all** other faces published in other sessions") + xlab("Round") + ylab("Face difference") # + theme(panel.background = element_blank())
p <- p + facet_wrap(~session, ncol=4)
p
ggsave(file="./img/ses2ses/dse.pub.cum_facet_session.jpg")


p <- ggplot(pr, aes(round)) 
p <- p + geom_point(aes(y = dse.pub.prev.mean.coo, color="COO"), alpha=0.2)
p <- p + geom_point(aes(y = dse.pub.prev.mean.com, color="COM"), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.pub.prev.mean.coo, color="COO"))
p <- p + geom_smooth(aes(y = dse.pub.prev.mean.com, color="COM"))
p <- p + scale_color_manual(values=c("#00bfc4", "#f9766e"), name="Distance\nfrom:")
p <- p + facet_wrap(~session,ncol=4) + ggtitle("Distance between current submissions of a session\n and faces published in the previous round in other sessions") + xlab("Round") + ylab("Face difference")
# + ggtitle("Between sessions innovation, grouped by COM and non-COM")
p
ggsave(file="./img/ses2ses/dse.pub.prev_facet_session_by_com.jpg")

p <- ggplot(pr, aes(round)) 
p <- p + geom_jitter(aes(y = dse.pub.cum.mean.coo, color="COO"), alpha=0.2)
p <- p + geom_jitter(aes(y = dse.pub.cum.mean.com, color="COM"), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.pub.cum.mean.coo, color="COO"))
p <- p + geom_smooth(aes(y = dse.pub.cum.mean.com, color="COM"))
p <- p + scale_color_manual(values=c("#00bfc4", "#f9766e"), name="Distance\nfrom:")
p <- p + facet_wrap(~session,ncol=4) + ggtitle("Distance between current submissions of a session\n and **all** other faces published in other sessions") + xlab("Round") + ylab("Face difference")
p
ggsave(file="./img/ses2ses/dse.pub.cum_facet_session_by_com.jpg")


p <- ggplot(pr, aes(round)) 
p <- p + geom_jitter(aes(y = dse.sub.curr.mean.coo, color="COO"), alpha=0.2)
p <- p + geom_jitter(aes(y = dse.sub.curr.mean.com, color="COM"), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.sub.curr.mean.coo, color="COO"))
p <- p + geom_smooth(aes(y = dse.sub.curr.mean.com, color="COM"))
p <- p + scale_color_manual(values=c("#00bfc4", "#f9766e"), name="Distance\nfrom:")
p <- p + facet_wrap(~session,ncol=4) + ggtitle("Between session distance of submissions at the same round") + xlab("Round") + ylab("Face difference")
p
ggsave(file="./img/ses2ses/dse.sub.curr_facet_session_by_com.jpg")


p <- ggplot(pr, aes(round, group=com, color=com)) 
p <- p + geom_jitter(aes(y = dse.sub.curr.mean.coo, color="COO"), alpha=0.2)
p <- p + geom_jitter(aes(y = dse.sub.curr.mean.com, color="COM"), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.sub.curr.mean.coo, color="COO"))
p <- p + geom_smooth(aes(y = dse.sub.curr.mean.com, color="COM"))
p <- p + scale_color_manual(values=c("#00bfc4", "#f9766e"), name="Distance\nfrom:")
p <- p + facet_grid(~com, labeller=myLabeller) + ggtitle("Between session distance of submissions at the same round") + xlab("Round") + ylab("Face difference")
p
ggsave(file="./img/ses2ses/dse.sub.curr_by_com.jpg")


p <- ggplot(pr, aes(round, group=com, color=com)) 
p <- p + geom_jitter(aes(y = dse.sub.curr.sd.coo, color="COO"), alpha=0.2)
p <- p + geom_jitter(aes(y = dse.sub.curr.sd.com, color="COM"), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.sub.curr.sd.coo, color="COO"))
p <- p + geom_smooth(aes(y = dse.sub.curr.sd.com, color="COM"))
p <- p + scale_color_manual(values=c("#00bfc4", "#f9766e"), name="Distance\nfrom:")
p <- p + facet_grid(~com, labeller=myLabeller) + ggtitle("Standard dev. of the distances betweeen submissions among sessions") + xlab("Round") + ylab("Std.dev. face difference")
p
ggsave(file="./img/ses2ses/dse.SD.sub.curr_by_com.jpg")


p <- ggplot(pr, aes(round, group=com, color=com)) 
p <- p + geom_jitter(aes(y = dse.pub.prev.sd.coo, color="COO"), alpha=0.2)
p <- p + geom_jitter(aes(y = dse.pub.prev.sd.com, color="COM"), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.pub.prev.sd.coo, color="COO"))
p <- p + geom_smooth(aes(y = dse.pub.prev.sd.com, color="COM"))
p <- p + scale_color_manual(values=c("#00bfc4", "#f9766e"), name="Distance\nfrom:")
p <- p + facet_grid(~com, labeller=myLabeller) + ggtitle("Standard dev. of the distances betweeen current submissions \nand faces published in the previous round in other sessions") + xlab("Round") + ylab("Std.dev. face difference")
p
ggsave(file="./img/ses2ses/dse.SD.pub.prev_by_com.jpg")


p <- ggplot(pr, aes(round, group=com, color=com)) 
p <- p + geom_jitter(aes(y = dse.pub.cum.sd.coo, color="COO"), alpha=0.2)
p <- p + geom_jitter(aes(y = dse.pub.cum.sd.com, color="COM"), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.pub.cum.sd.coo, color="COO"))
p <- p + geom_smooth(aes(y = dse.pub.cum.sd.com, color="COM"))
p <- p + scale_color_manual(values=c("#00bfc4", "#f9766e"), name="Distance\nfrom:")
p <- p + facet_grid(~com, labeller=myLabeller) + ggtitle("Standard dev. of the distance between current submissions of a session\n and **all** other faces published in other sessions") + xlab("Round") + ylab("Std.dev. face difference")
p
ggsave(file="./img/ses2ses/dse.SD.pub.cum_by_com.jpg")

p <- ggplot(pr, aes(round, group=com, color=com)) 
p <- p + geom_jitter(aes(y = dse.pub.cum.sd), alpha=0.2)
p <- p + geom_smooth(aes(y = dse.pub.cum.sd))
p <- p + ggtitle("Standard dev. of the distance between current submissions of a session\n and **all** other faces published in other sessions") + xlab("Round") + ylab("Std.dev. face difference")
p

ggsave(file="./img/ses2ses/dse.SD.pub.cum_by_com.jpg")


p <- ggplot(pr, aes(round, y = dse.pub.cum.sd, group=com, color=com)) 
p <- p + geom_jitter(alpha=0.2)
p <- p + geom_smooth()
p <- p + ggtitle("Standard dev. of the distance between current submissions of a session\n and **all** other faces published in other sessions") + xlab("Round") + ylab("Std.dev. face difference")
p


# TODO check here, mean is too high

p <- ggplot(pr, aes(round, y = dse.pub.cum.mean, group=com, color=com)) 
p <- p + geom_jitter(alpha=0.2)
p <- p + geom_smooth()
p <- p + ggtitle("Standard dev. of the distance between current submissions of a session\n and **all** other faces published in other sessions") + xlab("Round") + ylab("Std.dev. face difference")
p
