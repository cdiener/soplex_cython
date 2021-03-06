from libcpp cimport bool
from libcpp.string cimport string

cdef extern from "spxdefines.h":
    cdef int SOPLEX_VERSION
    cdef int SOPLEX_SUBVERSION

cdef extern from "spxgithash.h" namespace "soplex":
    cdef char* getGitHash()

cdef extern from "soplex.h" namespace "soplex":
    ctypedef float Real
    cdef Real infinity

    cdef cppclass Rational:
        Rational() except +
        Rational(int) except +
        Rational(double) except +
        Rational operator+ (Rational)
        Rational operator+ (Real)
        Rational operator- (Rational)
        Rational operator- (Real)
        Rational operator* (Rational)
        Rational operator* (Real)
        Rational operator/ (Rational)
        Rational operator/ (Real)
        double operator"double" ()
        long double operator"long double" ()
        int precision()
        bool readString(char *)
    cdef string rationalToString(Rational)

    cdef cppclass DSVectorBase[R]:
        DSVectorBase(int) except +
        DSVectorBase() except +
        void add(int, R)
    ctypedef DSVectorBase[Rational] DSVectorRational
    ctypedef DSVectorBase[Real] DSVectorReal

    cdef cppclass DVectorBase[R]:
        DVectorBase(int) except +
        DVectorBase() except +
        R operator[] (int)
    ctypedef DVectorBase[Rational] DVectorRational
    ctypedef DVectorBase[Real] DVectorReal

    cdef cppclass LPColBase[R]:
        LPColBase()  except +
        LPColBase(R, DSVectorBase[R], R, R)  except +
        void setLower(R)
        void setUpper(R)
        void upper(R)
        void lower(R)
    ctypedef LPColBase[Rational] LPColRational
    ctypedef LPColBase[Real] LPColReal

    cdef cppclass LPRowBase[R]:
        LPRowBase() except +
        LPRowBase(R, DSVectorBase[R], R) except +
        LPRowBase(DSVectorBase[R], RowType, R) except +
        void setType(int)
        void setLhs(R)
        void setRhs(R)
    ctypedef LPRowBase[Rational] LPRowRational
    ctypedef LPRowBase[Real] LPRowReal


    cdef cppclass SoPlex:
        SoPlex() except +
        STATUS solve() nogil
        STATUS status()
        bool hasPrimal()
        bool hasDual()
        int numIterations()
        Real solveTime()
        string statisticString()
        char * getStarterName()
        char * getScalerName()
        char * getPricerName()
        char * getRatioTesterName()
        bool areLPsInSync()
        
        # Settings functions
        bool boolParam(BoolParam param)
        int intParam(IntParam param)
        Real realParam(RealParam param)
        bool setBoolParam(BoolParam, bool) nogil
        bool setIntParam(IntParam, int) nogil
        bool setRealParam(RealParam, Real) nogil
        bool saveSettingsFile(char *filename)
        bool loadSettingsFile(char *filename)
        bool parseSettingsString(char *line)

        # Basis functions
        bool hasBasis()
        SPxBasis__SPxStatus basisStatus() 
        void getBasis(VarStatus[], VarStatus[]) nogil
        void setBasis(VarStatus[], VarStatus[]) nogil
        void clearBasis() nogil
        
        # Real functions
        int numRowsReal() nogil
        int numColsReal() nogil
        int numNonzerosReal() nogil
        void addColReal(LPColReal)
        void addRowReal(LPRowReal)
        Real objValueReal()
        void getPrimalReal(DVectorReal)
        void getDualReal(DVectorReal)
        void changeLowerReal(int, Real)
        void changeUpperReal(int, Real)
        void changeObjReal(int, Real)
        void changeElementReal(int, int, Real)
        void changeLhsReal(int, Real)
        void changeRhsReal(int, Real)
        void clearLPReal()
        void syncLPReal()
        bool writeFileReal(char *)
        # cython bug for optional arguments
        void writeStateReal(char *)
        void writeStateReal(char *, NameSet *rowNames)
        void writeStateReal(char *, NameSet *rowNames, NameSet *colNames)
        void writeStateReal(char *, NameSet *rowNames, NameSet *colNames, bool cpxFormat)

        # Rational functions
        int numRowsRational() nogil
        int numColsRational() nogil
        int numNonzerosRational() nogil
        void addColRational(LPColRational)
        void addRowRational(LPRowRational)
        Rational objValueRational()
        void getPrimalRational(DVectorRational)
        void getDualRational(DVectorRational)
        void changeLowerRational(int, Rational)
        void changeUpperRational(int, Rational)
        void changeObjRational(int, Rational)
        void changeElementRational(int, int, Rational)
        void changeLhsRational(int, Rational)
        void changeRhsRational(int, Rational)
        void clearLPRational()
        void syncLPRational()
        bool writeFileRational(char *)
        void writeStateRational(char *)
        void writeStateRational(char *, NameSet *rowNames)
        void writeStateRational(char *, NameSet *rowNames, NameSet *colNames)
        void writeStateRational(char *, NameSet *rowNames, NameSet *colNames, bool cpxFormat)

    ctypedef enum RowType "soplex::LPRow::Type":
        LESS_EQUAL "soplex::LPRow::LESS_EQUAL"
        EQUAL "soplex::LPRow::EQUAL"
        GREATER_EQUAL "soplex::LPRow::GREATER_EQUAL"
        RANGE "soplex::LPRow::GREATER_EQUAL"

    ctypedef enum BoolParam "soplex::SoPlex::BoolParam":
        LIFTING "soplex::SoPlex::LIFTING"
        EQTRANS "soplex::SoPlex::EQTRANS"
        TESTDUALINF "soplex::SoPlex::TESTDUALINF"
        RATFAC "soplex::SoPlex::RATFAC"
        ACCEPTCYCLING "soplex::SoPlex::ACCEPTCYCLING"
        RATREC "soplex::SoPlex::RATREC"
        POWERSCALING "soplex::SoPlex::POWERSCALING"
        RATFACJUMP "soplex::SoPlex::RATFACJUMP"
        FEASRELAX "soplex::SoPlex::FEASRELAX"
        BOOLPARAM_COUNT "soplex::SoPlex::BOOLPARAM_COUNT"

    ctypedef enum IntParam "soplex::SoPlex::IntParam":
        OBJSENSE "soplex::SoPlex::OBJSENSE"
        REPRESENTATION "soplex::SoPlex::REPRESENTATION"
        ALGORITHM "soplex::SoPlex::ALGORITHM"
        FACTOR_UPDATE_TYPE "soplex::SoPlex::FACTOR_UPDATE_TYPE"
        FACTOR_UPDATE_MAX "soplex::SoPlex::FACTOR_UPDATE_MAX"
        ITERLIMIT "soplex::SoPlex::ITERLIMIT"
        REFLIMIT "soplex::SoPlex::REFLIMIT"
        STALLREFLIMIT "soplex::SoPlex::STALLREFLIMIT"
        DISPLAYFREQ "soplex::SoPlex::DISPLAYFREQ"
        VERBOSITY "soplex::SoPlex::VERBOSITY"
        SIMPLIFIER "soplex::SoPlex::SIMPLIFIER"
        SCALER "soplex::SoPlex::SCALER"
        STARTER "soplex::SoPlex::STARTER"
        PRICER "soplex::SoPlex::PRICER"
        RATIOTESTER "soplex::SoPlex::RATIOTESTER"
        SYNCMODE "soplex::SoPlex::SYNCMODE"
        READMODE "soplex::SoPlex::READMODE"
        SOLVEMODE "soplex::SoPlex::SOLVEMODE"
        CHECKMODE "soplex::SoPlex::CHECKMODE"
        HYPER_PRICING "soplex::SoPlex::HYPER_PRICING"
        RATFAC_MINSTALLS "soplex::SoPlex::RATFAC_MINSTALLS"
        INTPARAM_COUNT "soplex::SoPlex::INTPARAM_COUNT"

    ctypedef enum RealParam "soplex::SoPlex::RealParam":
        FEASTOL "soplex::SoPlex::FEASTOL"
        OPTTOL "soplex::SoPlex::OPTTOL"
        EPSILON_ZERO "soplex::SoPlex::EPSILON_ZERO"
        EPSILON_FACTORIZATION "soplex::SoPlex::EPSILON_FACTORIZATION"
        EPSILON_UPDATE "soplex::SoPlex::EPSILON_UPDATE"
        EPSILON_PIVOT "soplex::SoPlex::EPSILON_PIVOT"
        INFTY "soplex::SoPlex::INFTY"
        TIMELIMIT "soplex::SoPlex::TIMELIMIT"
        OBJLIMIT_LOWER "soplex::SoPlex::OBJLIMIT_LOWER"
        OBJLIMIT_UPPER "soplex::SoPlex::OBJLIMIT_UPPER"
        FPFEASTOL "soplex::SoPlex::FPFEASTOL"
        FPOPTTOL "soplex::SoPlex::FPOPTTOL"
        MAXSCALEINCR "soplex::SoPlex::MAXSCALEINCR"
        LIFTMINVAL "soplex::SoPlex::LIFTMINVAL"
        LIFTMAXVAL "soplex::SoPlex::LIFTMAXVAL"
        SPARSITY_THRESHOLD "soplex::SoPlex::SPARSITY_THRESHOLD"
        REALPARAM_COUNT "soplex::SoPlex::REALPARAM_COUNT"

    ctypedef enum:
        OBJSENSE_MINIMIZE "soplex::SoPlex::OBJSENSE_MINIMIZE"
        OBJSENSE_MAXIMIZE "soplex::SoPlex::OBJSENSE_MAXIMIZE"

    cpdef enum STATUS "soplex::SPxSolver::Status":
        ERROR "soplex::SPxSolver::ERROR"
        NO_RATIOTESTER "soplex::SPxSolver::NO_RATIOTESTER"
        NO_PRICER "soplex::SPxSolver::NO_PRICER"
        NO_SOLVER "soplex::SPxSolver::NO_SOLVER"
        NOT_INIT "soplex::SPxSolver::NOT_INIT"
        ABORT_CYCLING "soplex::SPxSolver::ABORT_CYCLING"
        ABORT_TIME "soplex::SPxSolver::ABORT_TIME"
        ABORT_ITER "soplex::SPxSolver::ABORT_ITER"
        ABORT_VALUE "soplex::SPxSolver::ABORT_VALUE"
        SINGULAR "soplex::SPxSolver::SINGULAR"
        NO_PROBLEM "soplex::SPxSolver::NO_PROBLEM"
        REGULAR "soplex::SPxSolver::REGULAR"
        RUNNING "soplex::SPxSolver::RUNNING"
        UNKNOWN "soplex::SPxSolver::UNKNOWN"
        OPTIMAL "soplex::SPxSolver::OPTIMAL"
        INFEASIBLE "soplex::SPxSolver::INFEASIBLE"
        UNBOUNDED "soplex::SPxSolver::UNBOUNDED"
        INForUNBD "soplex::SPxSolver::INForUNBD"

    ctypedef enum:
        SYNCMODE_ONLYREAL "soplex::SoPlex::SYNCMODE_ONLYREAL"
        SYNCMODE_AUTO "soplex::SoPlex::SYNCMODE_AUTO"
        SYNCMODE_MANUAL "soplex::SoPlex::SYNCMODE_MANUAL"

    ctypedef enum:
        READMODE_REAL "soplex::SoPlex::READMODE_REAL"
        READMODE_RATIONAL "soplex::SoPlex::READMODE_RATIONAL"

    ctypedef enum:
        SOLVEMODE_REAL "soplex::SoPlex::SOLVEMODE_REAL"
        SOLVEMODE_AUTO "soplex::SoPlex::SOLVEMODE_AUTO"
        SOLVEMODE_RATIONAL "soplex::SoPlex::SOLVEMODE_RATIONAL"

    ctypedef enum:
        CHECKMODE_REAL "soplex::SoPlex::CHECKMODE_REAL"
        CHECKMODE_AUTO "soplex::SoPlex::CHECKMODE_AUTO"
        CHECKMODE_RATIONAL "soplex::SoPlex::CHECKMODE_RATIONAL"

cdef extern from "nameset.h" namespace "soplex":
    cdef cppclass NameSet:
        Name() except +
        Name(const char * str) except +

cdef extern from "spxsolver.h" namespace "soplex":
    cdef cppclass SPxSolver
    cpdef enum VarStatus "soplex::SPxSolver::VarStatus":
        ON_UPPER "soplex::SPxSolver::ON_UPPER"
        ON_LOWER "soplex::SPxSolver::ON_LOWER"
        FIXED "soplex::SPxSolver::FIXED"
        ZERO "soplex::SPxSolver::ZERO"
        BASIC "soplex::SPxSolver::BASIC"
        UNDEFINED "soplex::SPxSolver::UNDEFINED"

cdef extern from "spxbasis.h" namespace "soplex":
    cdef cppclass SPxBasis
    ctypedef enum SPxBasis__SPxStatus "soplex::SPxBasis::SPxStatus":
        SPxBasis_NO_PROBLEM "soplex::SPxBasis::NO_PROBLEM"
        SPxBasis_SINGULAR "soplex::SPxBasis::SINGULAR"
        SPxBasis_REGULAR "soplex::SPxBasis::REGULAR"
        SPxBasis_DUAL "soplex::SPxBasis::DUAL"
        SPxBasis_PRIMAL "soplex::SPxBasis::PRIMAL"
        SPxBasis_OPTIMAL "soplex::SPxBasis::OPTIMAL"
        SPxBasis_UNBOUDNED "soplex::SPxBasis::UNBOUDNED"
        SPxBasis_INFEASIBLE "soplex::SPxBasis::INFEASIBLE"
