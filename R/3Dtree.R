#' Main function to plot tree
#'
#' Will create a 3D tree. It positions tips randomly
#'
#' @param phy Phylo object
#' @param width.scaling How wide to make each branch relative to program defaults
#' @param new.window Should we open a new plotting window?
#' @export
#' @examples
#' phy <- ape::rcoal(10)
Plot3DTree <- function(phy,width.scaling=1, new.window=TRUE) {
  if (new.window) {
        rgl::open3d()
  }
  width <- width.scaling*max(phytools::nodeHeights(phy))/20
  rgl::rgl.material(shininess = 100)
  tips <- geiger::sim.char(phy=phy, par=1, nsim=2, model="BM")
  ancx <- ape::ace(tips[,,1], phy)$ace
  ancy <- ape::ace(tips[,,2], phy)$ace
  allx <- c(tips[,,1],ancx)
  ally <- c(tips[,,2],ancy)
  for (edge.index in sequence(nrow(phy$edge))) {
      end.node <- phy$edge[edge.index, 2]
      start.node <- phy$edge[edge.index, 1]
      start.point.horizontal <- c(allx[start.node], ally[start.node], phytools::nodeheight(phy,start.node))
      end.point.horizontal <-  c(allx[end.node], ally[end.node], phytools::nodeheight(phy,start.node))
      start.point.vertical <- end.point.horizontal
      end.point.vertical <- c(allx[end.node], ally[end.node], phytools::nodeheight(phy,end.node))
      coordinates.horizontal <- rbind(start.point.horizontal, end.point.horizontal)
      coordinates.vertical <- rbind(start.point.vertical, end.point.vertical)

      colnames(coordinates.horizontal) <- c('x', 'y', 'z')
      colnames(coordinates.vertical) <- c('x', 'y', 'z')
      try(rgl::shade3d(rgl::addNormals(rgl::subdivision3d(rgl::cylinder3d(coordinates.horizontal, radius=width, sides=8, twist=1, closed=-2), depth=2)), col="gray"))
      try(rgl::shade3d(rgl::addNormals(rgl::subdivision3d(rgl::cylinder3d(coordinates.vertical, radius=width, sides=8, twist=1, closed=-2), depth=2)), col="gray"))

      #print(coordinates)
      #rgl::lines3d(coordinates)
  }
}
