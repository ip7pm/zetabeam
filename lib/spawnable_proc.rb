module Beam

  class SpawnableProc < Beam::Spawnable
    def encapsulate_proc(proc) 
      define_singleton_method :run, proc
    end
  end
end
