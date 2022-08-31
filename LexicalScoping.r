## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function
## Assume we have a matrix M to find its inverse
## cacheMetrix <- makeCacheMatrix(M) provides four functions: set() set the matrix; get() get the matrix;
## setInverse() set the inverse matrix; getInverse() get the inverse matrix

makeCacheMatrix <- function(x = matrix()) {
## cacheSolve(cacheMetrix) calculates the inverse of the matrix M and save it into cacheMetrix
## And if the inverse already exists in cacheMetrix, then the funciton will directly get it

makeCacheMatrix <- function(x = matrix()) {
  iv <- NULL
  set <- function(y) {
    x <<- y
    iv <<- NULL
  }
  get <- function() x
  setInverse <- function(inverse) iv <<- inverse
  getInverse <- function() iv
  list(set = set, get = get,
       setInverse = setInverse,
       getInverse = getInverse)
}


## Write a short comment describing this function

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  iv <- x$getInverse()
  if(!is.null(iv)) {
    message("getting cached data")
    return(iv)
  }
  data <- x$get()
  iv <- solve(data, ...)
  x$setInverse(iv)
  return(iv)
}
